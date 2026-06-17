# Blueprint Writer Report

## Slug
a4b-auslander

## Status
COMPLETE — chapter created with full citation discipline; all required content
items present and grounded in `references/stacks-algebra.tex`. No reference
retrievals needed (Stacks already carries the Auslander–Buchsbaum proposition,
the depth-on-SES lemma, the depth and Cohen–Macaulay definitions, and the
regular ⇒ Cohen–Macaulay corollary). Matsumura was *not* fetched: the Stacks
source covers everything the directive required, and the directive listed the
Matsumura retrieval as conditional ("if so").

## Target chapter
blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex (NEW)

## Changes Made
- **New chapter** with `\chapter{Auslander--Buchsbaum}` and
  `% archon:covers AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` at top.
- **Added definition** `def:depth` / `\lean{RingTheory.Module.depth}` —
  regular-sequence definition of depth over a ring with an ideal, specialised
  to a Noetherian local ring.
- **Added lemma** `lem:depth_via_ext` /
  `\lean{RingTheory.Module.depth_eq_smallest_ext_index}` — Ext characterisation
  of depth. Source: Stacks tag 00LP. Proof sketch added: induction on depth via
  multiplication-by-x long exact Ext sequence.
- **Added definition** `def:projective_dimension` /
  `\lean{Module.projectiveDimension}` — infimum length of projective
  resolution; convention notes around `pd(0)`; minimal-resolution remark for
  local Noetherian. (Mathlib re-export expected — flagged in prose.)
- **Added lemma** `lem:depth_short_exact_sequence` /
  `\lean{RingTheory.depth_of_short_exact}` — the three-fold depth inequality
  on a SES of nonzero finite modules. Source: Stacks tag 00LE. Proof sketch
  added: long exact Ext sequence read-off.
- **Added theorem** `thm:auslander_buchsbaum` /
  `\lean{RingTheory.auslander_buchsbaum_formula}` — the formula
  `pd(M) + depth(M) = depth(R)` under (R Noetherian local, M finite nonzero
  fin pd). Source: Stacks tag 090V (proposition-Auslander-Buchsbaum). Proof
  sketch added: full Stacks-faithful induction on depth(M) with base case
  (minimal resolution + depth-on-SES iteration + what-is-exact criterion) and
  inductive step (common non-zero-divisor x reduces to R/xR-M/xM).
- **Added definition** `def:cohen_macaulay_local` /
  `\lean{RingTheory.CohenMacaulay}` — depth(R) = dim(R). Source: Stacks tag
  00N4.
- **Added corollary** `cor:regular_cohen_macaulay` /
  `\lean{RingTheory.CohenMacaulay.of_regular}` — regular local ⇒ CM. Source:
  Stacks tag 00OD. Proof sketch added: regular-sequence argument
  (independent of Auslander–Buchsbaum), plus a remark contrasting with the
  AB-via-finite-global-dim route.
- **Added application sketch** `sec:ab_application_to_a4a` — connects
  Corollary to the A.4.a codim-1 → codim-2 extension proof on a regular
  projective surface.
- **Added Lean encoding section** `sec:ab_lean_encoding` — notes the existing
  Mathlib API surface (`RingTheory.Ideal.RegularSequence`, possible
  `Module.depth` / `Module.projectiveDimension`) and what the new file must
  supply or re-export. Flags the Plan-Agent audit at pinned commit `b80f227`.
- **Added out-of-scope section** `sec:ab_out_of_scope` — codim-1 extension
  proof, local-cohomology vanishing, global CM, duality / Gorenstein.

## Cross-references introduced
- `def:depth` ← used in `lem:depth_via_ext`, `lem:depth_short_exact_sequence`,
  `thm:auslander_buchsbaum`, `cor:regular_cohen_macaulay`.
- `lem:depth_via_ext` ← used in proof of `lem:depth_short_exact_sequence`.
- `lem:depth_short_exact_sequence` ← used in proof of
  `thm:auslander_buchsbaum`.
- `def:projective_dimension` ← used in `thm:auslander_buchsbaum`.
- `def:cohen_macaulay_local` ← used in `cor:regular_cohen_macaulay`.
- `thm:auslander_buchsbaum` ← used in `cor:regular_cohen_macaulay`.
All cross-refs are internal to this chapter (no dependencies on sibling
chapters are introduced).

## References consulted
- `references/summary.md` — index check; confirmed Matsumura is not in the
  project's references but Stacks Algebra (`stacks-algebra.tex` /
  `stacks-algebra.md`) covers chapter 10 including depth and
  Auslander–Buchsbaum.
- `references/stacks-algebra.tex` —
  - L17743–17920 (section-depth): definition-depth (L17749–L17759, `def:depth`
    quote), lemma-depth-ext (L17845–L17885, `lem:depth_via_ext` statement +
    proof quote), lemma-depth-in-ses (L17887–L17920,
    `lem:depth_short_exact_sequence` statement + proof quote).
  - L25288–L25299 (definition-local-ring-CM, `def:cohen_macaulay_local`
    quote).
  - L25714–L25730 (lemma-regular-ring-CM, `cor:regular_cohen_macaulay`
    statement + proof quote).
  - L27207–L27280 (proposition-Auslander-Buchsbaum,
    `thm:auslander_buchsbaum` statement + proof quote).
- `blueprint/src/chapters/Picard_RelativeSpec.tex` — read for in-project
  citation-format conventions (`% SOURCE:` / `% SOURCE QUOTE:` /
  `% SOURCE QUOTE PROOF:` discipline, `\textit{Source: ...}` prefix,
  STRATEGY NOTE preamble, Lean-encoding section style).

## Macros needed (if any)
None. The chapter uses only standard LaTeX + the project's existing macros
(`\Spec`, `\Hom`, `\Ext` if defined; `\text{depth}` / `\text{pd}_R` /
`\text{Ext}^i_R` all written in `\text{...}` to be macro-independent).

## Reference-retriever dispatches (if any)
None. The directive flagged Matsumura as a possible retrieval target ("if so,
dispatch a child reference-retriever"); inspection showed Stacks tag 090V
carries the proposition statement *and* a complete induction proof verbatim
in `references/stacks-algebra.tex`, so a Matsumura fetch would have been
redundant — every `% SOURCE:` line in the chapter points to an already-local
file. Bruns–Herzog likewise not fetched for the same reason.

## Notes for Plan Agent
- **Stacks tag-vs-label mapping.** The `references/stacks-algebra.tex` file
  uses `\label{lemma-foo}` rather than embedded tag numbers; the
  tag-to-label correspondence is canonical
  (090V↔proposition-Auslander-Buchsbaum, 00LE↔lemma-depth-in-ses,
  00LP↔lemma-depth-ext, 00N4↔definition-local-ring-CM,
  00OD↔lemma-regular-ring-CM, 00LF↔definition-depth) but is *external
  knowledge* not directly visible in the .tex. If the reviewer wants to
  re-verify the tag↔label mapping, the canonical source is
  `https://stacks.math.columbia.edu/tag/090V` etc. — they all resolve to the
  labels I cited.
- **Mathlib status audit needed at b80f227.** The chapter assumes the prover
  will re-export rather than redefine `Module.depth`,
  `Module.projectiveDimension`, and `IsCohenMacaulayLocalRing` if they exist
  in Mathlib at the pinned commit. The directive asked me not to speculate
  on the exact API shape, so I described the *mathematical content* the
  Lean signature must match and noted in the Lean-encoding section that the
  Plan Agent should confirm:
  - whether `Mathlib.RingTheory.Depth` exists at `b80f227`,
  - whether `auslander_buchsbaum_formula` or
    `Module.auslanderBuchsbaum` is already in Mathlib (would collapse this
    chapter to a `mathlibok` wrapper),
  - whether `IsCohenMacaulayLocalRing` is exposed.
  Suggested verification: `lean_local_search "auslander_buchsbaum"`,
  `lean_local_search "Module.depth"`, `lean_local_search "CohenMacaulay"`
  on the prover side before writing
  `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`.
- **Application section is intentionally a sketch, not a chapter.** The
  codim-1 extension proof (A.4.a's geometric content) lives in a different
  sibling chapter that does not yet exist. Section
  `sec:ab_application_to_a4a` is just enough motivation to make the
  consumer-facing role of `cor:regular_cohen_macaulay` legible.
- **Out-of-scope local cohomology.** I cited Stacks tag 0AVF (depth via
  local cohomology) in the application section as the bridge between depth
  and the `H^i_x` vanishings A.4.a actually needs, but did not formalize
  it — the directive explicitly framed local cohomology as future-work
  (Mathlib has only partial coverage).

## Strategy-modifying findings
None. The chapter content matches STRATEGY.md's framing of A.4.b verbatim:
Auslander–Buchsbaum is independently startable from A.4.a (algebra-only,
under `RingTheory.*`), and the regular ⇒ CM corollary is the precise
consumer-facing output. Two minor caveats worth a strategy follow-up at
some point — neither is a strategy bug, neither blocks current work:

- If Mathlib's `b80f227` revision already ships
  `Module.auslanderBuchsbaum` (or `RingTheory.auslander_buchsbaum_formula`)
  proper, then A.4.b becomes a 1-iter re-export rather than the
  ~4-7-iter / ~500-700-LOC estimate in STRATEGY.md L30. The Plan-Agent
  audit will determine which.
- The Ext-based depth characterisation (Lemma `lem:depth_via_ext`) is
  written here as an internal-to-chapter intermediate. If Mathlib's depth
  API uses regular sequences directly (no Ext), the chapter's proof of
  `lem:depth_short_exact_sequence` will need a slight rephrasing to a
  regular-sequence-direct argument. The result statement stays the same;
  only the proof presentation would change. This is a chapter-level
  refactor, not strategy-level.
