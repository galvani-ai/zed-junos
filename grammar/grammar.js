/**
 * @file Tree-sitter grammar for Juniper Junos configuration files.
 *
 * Supports both syntaxes:
 *   - hierarchical (curly-brace) format:  `system { host-name r1; }`
 *   - flat "display set" format:           `set system host-name r1`
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: 'junos',

  // Newlines are significant (they end `set` commands), so they are NOT extras.
  extras: $ => [
    /[ \t\r\f\v\uFEFF]/,
    $.comment,
  ],

  rules: {
    // A command runs until the end of its line, so it must be followed by a
    // newline (or be the very last thing in the file). This keeps verbs such
    // as `set` usable as plain values inside a command line.
    source_file: $ => seq(
      repeat(choice(
        $.statement,
        seq($.command, $._newline),
        $.edit_context,
        $._newline,
      )),
      optional($.command),
    ),

    // ---------------------------------------------------------------------
    // Hierarchical format
    // ---------------------------------------------------------------------

    statement: $ => seq(
      optional(field('status', $.status)),
      field('name', $._name),
      optional(field('arguments', $.arguments)),
      choice(';', field('body', $.block)),
    ),

    status: _ => choice(
      'inactive:',
      'active:',
      'protect:',
      'unprotect:',
      'replace:',
      'delete:',
    ),

    block: $ => seq(
      '{',
      repeat(choice($.statement, $._newline)),
      '}',
    ),

    // ---------------------------------------------------------------------
    // Flat "set" format / CLI commands
    // ---------------------------------------------------------------------

    command: $ => prec.right(seq(
      field('verb', $.verb),
      optional(field('arguments', $.arguments)),
    )),

    verb: _ => choice(
      'set',
      'delete',
      'deactivate',
      'activate',
      'insert',
      'annotate',
      'rename',
      'copy',
      'protect',
      'unprotect',
      'edit',
      'wildcard',
      'up',
      'top',
      'exit',
      'quit',
      'show',
      'run',
      'load',
      'commit',
      'rollback',
      'replace',
      'status',
    ),

    // `[edit interfaces ge-0/0/0]` banners printed by the CLI
    edit_context: $ => seq(
      '[',
      'edit',
      optional($.arguments),
      ']',
    ),

    // ---------------------------------------------------------------------
    // Values
    // ---------------------------------------------------------------------

    arguments: $ => prec.right(repeat1($._value)),

    _name: $ => choice($.word, $.string),

    _value: $ => choice($.word, $.string, $.list),

    list: $ => seq(
      '[',
      repeat(choice($.word, $.string, $._newline)),
      ']',
    ),

    word: _ => /[^\s{};\[\]"#]+/,

    string: $ => seq(
      '"',
      repeat(choice(
        $.string_content,
        $.escape_sequence,
      )),
      '"',
    ),

    string_content: _ => token.immediate(prec(1, /[^"\\]+/)),

    escape_sequence: _ => token.immediate(/\\./),

    comment: _ => token(choice(
      seq('#', /[^\n]*/),
      seq('/*', /[^*]*\*+([^/*][^*]*\*+)*/, '/'),
    )),

    _newline: _ => /\n/,
  },
});
