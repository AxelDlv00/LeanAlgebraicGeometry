# Blueprint Writer Directive

## Slug
cov274-lbc

## Target chapter
blueprint/src/chapters/Picard_LineBundleCoherence.tex

## Strategy context
This is a 1-to-1 Lean↔blueprint COVERAGE-CLOSURE pass (DAG completeness criterion 5).
The project maintains a strict correspondence: every Lean declaration needs a blueprint
block. The declarations listed below exist in Lean (proved directly, sorry-free in most
cases) but currently have NO \lean{}-pinned blueprint block — leandag reports them as
uncovered lean-aux nodes. They are INTERNAL HELPER declarations: there is NO external
mathematical source, so do NOT add %SOURCE / %SOURCE QUOTE / \textit{Source} citation
blocks. Each gets a faithful one-line statement and a short proof note.

## Required content
For EACH Lean declaration listed below, add ONE additive blueprint block
(\begin{lemma}, \begin{definition}, \begin{proposition} as fits its kind) to the chapter:
  - a human-readable name in [brackets];
  - \label{<type:descriptive_label>} (type prefix matching the block kind: def:/lem:/prop:);
  - \lean{<the EXACT fully-qualified Lean name printed below>};
  - a CONCISE, faithful one-line mathematical statement in the project's notation. READ THE
    LEAN SIGNATURE AND DOCSTRING in AlgebraicJacobian/Picard/LineBundleCoherence.lean to state it correctly — do not invent content;
  - statement-level \uses{...} that wires the block into the chapter cone (see WIRING);
  - a \begin{proof} whose body is "Proved directly in Lean." (no math sketch required for
    these helpers, but the proof environment MUST be present so the node is not an infinity hole).

Declarations to cover (all live in AlgebraicJacobian/Picard/LineBundleCoherence.lean):
- AlgebraicGeometry.Scheme.LineBundle.freeUnitIso
- AlgebraicGeometry.Scheme.LineBundle.unitGenerators
- AlgebraicGeometry.Scheme.LineBundle.unitPresentation

## WIRING (critical — prevents isolated nodes; this is the part prior passes got wrong)
leandag builds dependency edges ONLY from STATEMENT-LEVEL \uses{}. A \uses{} placed inside a
\begin{proof} block contributes NO edge. So every new block must carry a statement-level
\uses{} that connects it:
  - if the helper is USED BY an existing covered declaration in this chapter, hoist the new
    \label into THAT consumer block's statement-level \uses{};
  - if the helper DEPENDS ON an already-covered declaration here, put that label in the new
    block's own statement-level \uses{};
  - chains of these new helpers may \uses{} each other, but the chain root must connect to an
    existing covered node so the whole cluster is wired into the chapter.
After editing run `leandag build --json` then `leandag query --isolated --chapter Picard_LineBundleCoherence`
and confirm NONE of your new blocks is isolated and you introduced no unknown \uses{}. Fix and
re-verify before reporting COMPLETE.

## Out of scope
- Do NOT add \leanok (owned by the deterministic sync_leanok phase).
- Do NOT cover any declaration not in the list above.
- Do NOT edit other chapters or rewrite unrelated existing prose (the only edits to existing
  blocks permitted are statement-level \uses{} hoists described under WIRING).


## References
None — internal project helpers, no external source. Omit every citation block.

## Expected outcome
The chapter gains additive \lean{}-pinned coverage blocks for every listed declaration, each
faithfully stated, each wired by statement-level \uses{}, none isolated, no broken \uses{}.
leandag's uncovered lean-aux count for AlgebraicJacobian/Picard/LineBundleCoherence.lean drops to zero.
