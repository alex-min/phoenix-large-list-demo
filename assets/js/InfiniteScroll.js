require('fattable/fattable.js');


/* 
 * This variable is used to keep the scroll position when the live view navigation changes.
 * This is useful for modals.
*/
let keepScroll = {};

export default {
    mounted() {
        /*
         * Here we're loading the first page which is already rendered in the HTML 
         */
        var firstBlock = [];
        for (let i = 0; i < this.el.children.length; i++) {
            firstBlock.push(this.el.children[i].outerHTML);
        }

        /* 
         *  All the attributes are mapped from what we sent in the live view 
         */
        const numberOfRows = parseInt(this.el.getAttribute('data-count'));
        const pageSize = parseInt(this.el.getAttribute('data-page-size'));
        const rowHeight = parseInt(this.el.getAttribute('data-row-height'));
        const loadingBlock = document.getElementById(this.el.getAttribute('data-loading-block-id')).innerHTML;

        let painter = new fattable.Painter();

        painter.fillCell = (cellDiv, data) => cellDiv.innerHTML = data.content;   // filling the data when it's received
        painter.fillCellPending = (cellDiv) => cellDiv.innerHTML = loadingBlock;  // the loading block when there's no data

        let tableModel = new fattable.PagedAsyncTableModel();

        tableModel.cellPageName = (i) => (i / pageSize) | 0;
        tableModel.hasColumn = () => true;
        tableModel.columnHeaders = ["Transaction"];
        tableModel.getHeader = (i, cb) => cb(tableModel.columnHeaders[i]);


        /*
         * This is where we fetch the current page to render the header
         * We're using Live View events instead of HTTP requests since the socket is already opened
         * If it's the first page, we render the elements we gathered already from the server side rendering, no need to fetch them again
         */
        tableModel.fetchCellPage = (offset, cb) => {
            if (offset == 0) {
                cb(function (i) {
                    return {
                        rowId: i,
                        content: firstBlock[i]
                    }
                });
            } else {
                this.pushEventTo(`#${this.el.id}`, "load-table", { offset: offset });
                this.handleEvent(`${this.el.id}-receive-table-${offset}`, payload => {
                    cb(function (i) {
                        return {
                            rowId: i,
                            content: payload.html[i - payload.offset * pageSize]
                        }
                    });
                });
            }
        }

        /* 
         * This is used to resize the list if the window size changes 
         */
        let getColumnWidth = () => {
            return [this.el.getClientRects()[0].width];
        }

        this.table = fattable({
            container: `#${this.el.id}`,
            model: tableModel,
            nbRows: numberOfRows,
            rowHeight,
            headerHeight: 0,
            painter,
            columnWidths: getColumnWidth()
        });

        window.addEventListener('resize', () => {
            this.table.columnWidths = getColumnWidth()
        });

        /*
         * We set the scroll to where it was before, this object isn't stored in the localStorage,
         * this is by design, we want the list to be scrolled top when the user actually reloads the page, same as an actual list.
         */
        if (keepScroll[this.el.id]) {
            this.table.scroll.setScrollXY(0, keepScroll[this.el.id]);
        }
    },

    /*
     * This will be called before the table is destroyed to save the scroll position, this is very useful for modals.
     */
    beforeDestroy() {
        keepScroll[this.el.id] = this.table.scroll.scrollTop;
    }
}