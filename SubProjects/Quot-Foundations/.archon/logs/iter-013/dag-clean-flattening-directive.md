# Blueprint Clean Directive

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Focus
This iteration added a cluster of concise **GenericFreeness Nagata-machinery helper** blocks to this chapter to close the Lean↔blueprint
1-to-1 coverage debt (prover-generated internal helpers, now blueprinted). Audit the WHOLE chapter but
pay particular attention to these newly-added helper blocks:

1. **Strip Lean leakage**: the helpers are technical, so the writer may have leaked Lean-syntactic
   prose (tactic names, typeclass wiring, term-mode expressions, `finSuccEquiv`-style raw identifiers
   used as prose, Lean coercion notation). Rewrite any such passage as plain mathematics. The only
   permitted Lean reference is the \lean{} annotation.
2. **No project history**: remove any "iteration N", "prover", "helper added", "scaffold" narrative.
3. **Concision**: helper blocks should be 1–3 lines of statement + a one-line proof or
   "Proved directly in Lean." note. Trim verbosity.
4. **LaTeX / refs**: confirm \label{}, \lean{}, \uses{} are well-formed; no literal REF tokens; no
   interleaved math delimiters; every macro defined. Do NOT add \leanok.

## Citation
These helper blocks are project-internal/Archon-original — no external % SOURCE QUOTE: is required for
them. Do NOT fabricate citations. Leave the chapter's pre-existing externally-sourced blocks' quotes
intact; only add a missing quote if a pre-existing block clearly references a reference already in
references/ but lacks its verbatim quote.

## Out of scope
Do NOT alter the mathematical statements of the chapter's main (pre-existing) theorems/definitions.
Do NOT touch other chapters.
