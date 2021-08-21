const conventionalCommit = require("./conventionalCommit.json");

const typesEnum = Object.keys(conventionalCommit.types);

module.exports = {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "type-enum": [2, "always", typesEnum],
    "scope-case": [2, "always", ["camel-case"]]
  },
};