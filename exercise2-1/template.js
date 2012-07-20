var Template = function(input) {
    // この関数を実装してください
    this.source = input.source;
};

Template.prototype = {
    render: function(variables) {
        // この関数を実装してください
        return this.source.replace(/{%\s*([^%\s}]+)\s*%}/g, function(m0, m1){
            return Util.htmlspecialchars(variables[m1]);
        });
    }
};

// 名前空間の汚染を防ぐ
var Util = {
    htmlspecialchars: function (str) {
        str = str.replace(/&/g, "&amp;");
        str = str.replace(/"/g, "&quot;");
        str = str.replace(/'/g, "&#039;");
        str = str.replace(/</g, "&lt;");
        str = str.replace(/>/g, "&gt;");
        return str;
    }
};
