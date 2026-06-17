# Blueprint Clean — iter-059

## Summary

Purity pass on the blocks added/edited this iteration in two files.

---

## Picard_FlatteningStratification.tex

### Blocks inspected
Four new transport-helper lemmas (`lem:gf_pullback_module_transport`,
`lem:gf_finite_of_quotient_ringequiv`, `lem:gf_islocalizedmodule_restrictscalars`,
`lem:gf_away_tower_descent`) plus the expanded proof sections of
`lem:gf_torsion_reindex` ("Localisation transport" and "Action-diamond subtlety").

### Changes made

**`lem:gf_away_tower_descent` — statement and proof**: The notation
`\mathrm{Away}(g)` / `\mathrm{Away}(h)` / `\mathrm{Away}(f)` / `\mathrm{Away}(ga)`
throughout was the Lean `IsLocalization.Away` concept leaking into the prose.
Replaced everywhere with standard mathematical notation:
- `\mathrm{Away}(g)` → `A[g^{-1}]` (in statement definitions)
- `\mathrm{Away}(h)` → `A_g[h^{-1}]`
- `\mathrm{Away}(f)` → `A[f^{-1}]`
- `\mathrm{Away}(ga)` → `A_{ga}` (in proof body)
- `T_{g\,a}` → `T_{ga}` (consistent notation)
- Lemma display title: "descent of freeness across a tower of Away localisations"
  → "descent of freeness across an iterated localisation"

**`lem:gf_torsion_reindex` proof — "Action-diamond subtlety" section**: The phrase
"One cannot simply install an anonymous A_g-action by fiat" is Lean typeclass
language (referring to definitional instance conflicts), not standard mathematical
prose. Renamed the subsection "Module structure and scalar tower" and rephrased the
argument in terms of: the canonical localisation action must match the required
scalar-tower action, and this is verified by showing the two constructions agree.

### Blocks with no changes needed
`lem:gf_pullback_module_transport`, `lem:gf_finite_of_quotient_ringequiv`,
`lem:gf_islocalizedmodule_restrictscalars`: all clean — purely mathematical
statements and proofs with no Lean leakage.  The "Localisation transport"
subsection of `lem:gf_torsion_reindex`: also clean.

---

## Picard_SectionGradedRing.tex

### Blocks inspected
`def:relTensorActR`, `def:relTensorProj`, expanded step-2 / step-3 of
`lem:relativeTensor_as_coequalizer`.

### Changes made

**`def:relTensorActR` — naturality justification**: Removed the Lean declaration
name `\mathrm{PresheafOfModules.map\_smul}` used as an in-prose parenthetical.
Replaced with the mathematical fact it names: "the O_X-semilinearity of the
restriction maps of Q".

**`def:relTensorProj` — "Route for the naturality verification" section**: Removed
entirely. This ~25-line paragraph discussed `CommRingCat → RingCat` forgetful-functor
elaboration, the "carrier" of `O_X(V)` as a plain ring vs. a commutative ring, and
constructing a module-presheaf intermediate to work around type-checking issues.
This is exclusively Lean elaboration strategy with no mathematical content beyond
what the preceding "Naturality" paragraph already states and proves on elementary
tensors. Removing it leaves the definition with a complete, coherent informal proof
of naturality.

### Blocks with no changes needed
Expanded steps 2 and 3 of `lem:relativeTensor_as_coequalizer` proof: mathematically
clean; `def:relTensorActL, def:relTensorActR, def:relTensorProj` cross-references
correctly added to `\uses{}` in both statement and proof blocks (these are the
`\uses` fixes mentioned in the directive — left intact per instructions).

---

## Items not changed (per directive)

- All `\lean{}` pins, `\label{}`, `\uses{}` entries, `\leanok`, `\mathlibok` markers
  left untouched.
- No unrelated blocks modified.
- No references missing citations were found in the new blocks (the helpers cite no
  external sources, as expected for general module-theory lemmas; the SectionGradedRing
  blocks inherit existing citations).
