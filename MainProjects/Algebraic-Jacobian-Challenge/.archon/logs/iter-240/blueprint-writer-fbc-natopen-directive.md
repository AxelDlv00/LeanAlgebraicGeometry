# Blueprint Writer Directive — FlatBaseChange: pin new decls + natural-in-open note

## Chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

## Scope (narrow — additive, do NOT rewrite the existing movements)
The lemma `lem:pushforward_spec_tilde_iso` (statement ~L356–392, proof ~L394–520)
is mathematically faithful and its three movements (the `e_{D(a)}` linear
equivalence, the `D(a)`-ring equation, the transport discharge of `hloc`) are
CORRECT — do not rewrite them. Two focused additions only:

### (A) Add two new `\lean{}`-pinned blocks for the iter-239 axiom-clean bricks
The iter-239 prover built two reusable axiom-clean declarations that realize
movement (1) and its `R'`-side input but currently have NO blueprint block.
Add a lemma block for each, near `lem:gammaPushforwardIso` (~L199) so the DAG
reflects them:

1. **`gammaPushforwardIsoAt`** — the open-indexed generalization of
   `lem:gammaPushforwardIso`. State: for any open `U` of `Spec R`,
   `Γ((Spec φ)_* N, U) ≅ restr_φ (Γ(N, (Spec φ)⁻¹ U))`, naturally; it is the
   `e_{D(a)}` of movement (1) for `U = D(a)`. `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}`,
   `\uses{lem:globalSectionsIso_hom_comp_specMap_appTop}` (its proof copies
   `gammaPushforwardIso` with `⊤` replaced by an arbitrary `U`).
2. **`tildeRestriction_isLocalizedModule`** — the `R'`-side localization input:
   the tilde restriction `Γ(M^~, ⊤) → Γ(M^~, D(b))` (read as `R'`-modules) is an
   `IsLocalizedModule (powers b)` localization. `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}`.
   (This is the known `R'`-side fact transported in movement (3).)

Keep these as Archon-original project-infrastructure blocks (no external
`% SOURCE` needed — they are the affine tilde dictionary, same provenance as the
existing `lem:gammaPushforwardIso`).

### (B) Add a "natural in the open" note to the movement-(1)/(3) prose
The iter-239/240 analysis (mathlib-analogist `fbc-qc`, persistent file
`analogies/fbc-qc.md`) found that the clean way to discharge `hloc` is to make
the family `{e_{D(a)}}_a` (i.e. `gammaPushforwardIsoAt`) **natural in the open
argument** — the structure-sheaf restriction maps on both sides commute with the
isomorphisms — so the per-`a` localization transport of movement (3) follows from
the `⊤`-level localization plus naturality, rather than re-proving a section-level
naturality square by hand for each `a`. Add one short paragraph (after movement
(2) or inside movement (3)) recording this: the comparison
`(Spec φ)_* ∘ (-)^~ ≅ (-)^~ ∘ restr_φ` is natural in BOTH the module and the open,
and the open-naturality is what drives the localization transport uniformly.
State plainly (math-level) that the relevant `R`-module structure on the
`R'`-side sections used by the ring-change converse `lem:powers_restrictScalars`
is the honest restriction-of-scalars structure (`R` acting through `φ`), i.e. the
`Algebra R R'` / scalar-tower structure of `φ`, NOT an ad-hoc recursive scalar
action — this is the structure under which `lem:powers_restrictScalars` was
stated.

### (C) One-sentence upstream-alignment note
Add (as a `% NOTE:` comment or a sentence in the closing "quasi-coherence as a
corollary" paragraph) that this lemma is the affine case of "the pushforward of a
quasi-coherent sheaf along an affine morphism is quasi-coherent", which in current
Mathlib master is the `IsLocalizing`/`fromTildeΓ` characterization
(`isIso_fromTildeΓ_pushforward`); it post-dates the project's pin, so the project
proves it in-tree via the route above (the in-tree proof remains valid and is not
wasted by a future Mathlib bump).

## Hard constraints
- Additive only. Do NOT rewrite movements (1)–(3) or the statement.
- Do NOT add/remove `\leanok` / `\mathlibok` (managed by sync_leanok / review).
  Adding `\lean{}` pins to the two new blocks is REQUIRED and is the writer's job.
- Math-level prose only — NO Lean tactic names (`algebraize`, `letI`, etc.) in the
  blueprint. Describe the `R`-action as restriction-of-scalars / the `Algebra`
  structure of `φ`, not as a tactic.
- Read `analogies/fbc-qc.md` first for the precise upstream citations.
