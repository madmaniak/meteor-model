// cutted https://github.com/gmosx/inflection/blob/master/lib/inflection.js

var inflections = {
    singulars: [],
    uncountables: []
};

var SINGULARS = inflections.singulars,
    UNCOUNTABLES = inflections.uncountables;

var singular = function (rule, replacement) {
    inflections.singulars.unshift([rule, replacement]);
}

var uncountable = function (word) {
    inflections.uncountables.unshift(word);
}

var irregular = function (s, p) {
    if (s.substr(0, 1).toUpperCase() == p.substr(0, 1).toUpperCase()) {
        singular(new RegExp("(" + p.substr(0, 1) + ")" + p.substr(1) + "$", "i"), '$1' + s.substr(1));
    } else {
        singular(new RegExp(p.substr(0, 1).toUpperCase() + p.substr(1) + "$"), s.substr(0, 1).toUpperCase() + s.substr(1));
        singular(new RegExp(p.substr(0, 1).toLowerCase() + p.substr(1) + "$"), s.substr(0, 1).toLowerCase() + s.substr(1));
    }
}

singular(/s$/i, "")
singular(/(n)ews$/i, "$1ews")
singular(/([ti])a$/i, "$1um")
singular(/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)ses$/i, "$1$2sis")
singular(/(^analy)ses$/i, "$1sis")
singular(/([^f])ves$/i, "$1fe")
singular(/(hive)s$/i, "$1")
singular(/(tive)s$/i, "$1")
singular(/([lr])ves$/i, "$1f")
singular(/([^aeiouy]|qu)ies$/i, "$1y")
singular(/(s)eries$/i, "$1eries")
singular(/(m)ovies$/i, "$1ovie")
singular(/(x|ch|ss|sh)es$/i, "$1")
singular(/([m|l])ice$/i, "$1ouse")
singular(/(bus)es$/i, "$1")
singular(/(o)es$/i, "$1")
singular(/(shoe)s$/i, "$1")
singular(/(cris|ax|test)es$/i, "$1is")
singular(/(octop|vir)i$/i, "$1us")
singular(/(alias|status)es$/i, "$1")
singular(/^(ox)en/i, "$1")
singular(/(vert|ind)ices$/i, "$1ex")
singular(/(matr)ices$/i, "$1ix")
singular(/(quiz)zes$/i, "$1")
singular(/(database)s$/i, "$1")

irregular("person", "people");
irregular("man", "men");
irregular("child", "children");
irregular("sex", "sexes");
irregular("move", "moves");
irregular("cow", "kine");

uncountable("equipment");
uncountable("information");
uncountable("rice");
uncountable("money");
uncountable("species");
uncountable("series");
uncountable("fish");
uncountable("sheep");
uncountable("jeans");

singularize = function (word) {
    var wlc = word.toLowerCase();

    for (var i = 0; i < UNCOUNTABLES.length; i++) {
        var uncountable = UNCOUNTABLES[i];
        if (wlc == uncountable) {
            return word;
        }
    }

    for (var i = 0; i < SINGULARS.length; i++) {
        var rule = SINGULARS[i][0],
            replacement = SINGULARS[i][1];
        if (rule.test(word)) {
            return word.replace(rule, replacement);
        }
    }
}
