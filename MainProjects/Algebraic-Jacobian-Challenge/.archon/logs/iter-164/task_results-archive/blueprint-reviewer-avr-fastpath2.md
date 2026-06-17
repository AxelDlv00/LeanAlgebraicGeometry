# Blueprint Review Report

## Slug
avr-fastpath2

## Iteration
164

## Fast-path gate verdict (the dispatch's headline)

**`AbelianVarietyRigidity.tex` is now `complete: true` + `correct: true` with NO must-fix
finding.** The fast-path gate **CLEARS**: `AlgebraicJacobian/AbelianVarietyRigidity.lean` may
go into this iter's prover objectives.

The two genus-0 frontier blocks that failed my prior dispatch are now prover-ready under the
re-routed **𝔾_m-scaling shortcut**. All three gate questions answered below.

### Gate Q1 — `prop:morphism_P1_to_AV_constant` scaling-shortcut proof: PROVER-READY

The proof (lines 1211–1266) is detailed, math-sound, and consumes only proven/well-defined
inputs. I verified the math end-to-end:

- **Base-point condition for Cor 1.5.** `V = ℙ¹` (proper/complete — the only factor the proven
  Lean Cor 1.5 needs complete, per the iter-163 NOTE at L698–705), `W = 𝔾_m`, base points
  `v₀ = 0 ∈ ℙ¹`, `w₀ = 1 ∈ 𝔾_m`. Then `h(0,1) = f(σ_×(0,1)) = f(1·0) = f(0) = 0_A` after the
  normalising translation — exactly the `h(v₀,w₀)=0` hypothesis. ✓
- **V-axis restriction = f.** `f₀(x) = h(x,1) = f(σ_×(x,1)) = f(1·x) = f(x)` (uses `σ_×(x,1)=x`,
  the action-identity, established in `def:gaTranslationP1`). ✓
- **W-axis collapse (load-bearing fixed point).** `g(λ) = h(0,λ) = f(σ_×(0,λ)) = f(0) = 0_A`
  (uses `σ_×(0,λ)=0`, the scaling fixed point, established in `def:gaTranslationP1`). So `g` is
  the hom-group identity, `q ≫ g` is the identity summand, and the existence-half decomposition
  collapses to `h = p ≫ f`, i.e. `σ_× ≫ f = pr₁ ≫ f` (`f(λx)=f(x)`). This matches the
  EXISTENCE-only Lean signature of Cor 1.5 (canonical axis-restriction witnesses inlined)
  exactly — no reliance on the unformalized uniqueness half. ✓
- **Specialisation + density.** Precomposing with `λ ↦ (1,λ)` gives `f|_{𝔾_m} = const_{f(1)}`
  (since `s ≫ σ_× = (λ↦λ)` = the 𝔾_m ↪ ℙ¹ inclusion, `s ≫ pr₁ = const₁`). Then `𝔾_m` dense in
  irreducible `ℙ¹` + `A` separated ⟹ `f` constant via `thm:GrpObj_eq_of_eqOnOpen`. ✓ Final
  constant value `f(1) = f(0) = 0_A` is internally consistent (no hidden `f(1)=0` assumption). ✓

Inputs are all genuinely proven (not laundered): `lem:hom_additivity_over_product`
(`hom_additive_decomp_of_rigidity`, proven over the iter-162 axiom-clean rigidity chain),
`thm:GrpObj_eq_of_eqOnOpen` (`Scheme.Over.ext_of_eqOnOpen`, `\leanok` in `Rigidity.tex`,
backed by Mathlib `ext_of_isDominant_of_isSeparated'`). The "image of a group homomorphism is a
closed subgroup" Mathlib gap is genuinely avoided — confirmed, the proof never forms the
additive defect map nor invokes `Hom(𝔾_a,A)=0`.

### Gate Q2 — `def:genus0_base_objects` + `def:gaTranslationP1`: scaffoldable

- `def:genus0_base_objects` (L897–926): ℙ¹/𝔾_a/𝔾_m over Spec k̄ specified concretely —
  distinguished points `0,1,∞`, the two standard charts `𝔸¹ = ℙ¹∖{∞}` (coord `x`) and
  `ℙ¹∖{0}` (coord `u=1/x`), group laws, finite-type/properness. `\lean{ProjectiveLineBar}`
  [expected]. Acceptable as a definition scaffold.
- `def:gaTranslationP1` (L928–976): the σ_× action carries the **required chartwise
  total-morphism computation**: on `𝔸¹×𝔾_m` (target chart `x`) `(x,λ)↦λx` polynomial/regular;
  near `∞` (chart `u=1/x`) the target coord `1/(λx) = u/λ` is regular because `λ∈𝔾_m`
  invertible; charts cover + overlap consistently ⟹ total. Left-action laws + two fixed points
  `σ_×(0,λ)=0`, `σ_×(∞,λ)=∞` stated. `\lean{gmScalingP1}` [expected]. Concrete enough to
  scaffold; the demoted 𝔾_a-translation companion σ has the analogous chart computation.

Both definitions are still `sorry`/[expected] infra in Lean — acceptable for definition blocks
per the directive's sanction on prior scaffolds.

### Gate Q3 — `\uses` graph, demoted blocks, laundering

- **Forward-acyclic.** Critical-path edges run strictly forward:
  `thm:rigidity_genus0_curve_to_AV` → {`prop:morphism_P1_to_AV_constant`,
  `prop:genusZero_curve_iso_P1`}; `prop:morphism_P1_to_AV_constant` →
  {`lem:hom_additivity_over_product`, `def:gaTranslationP1`, `thm:GrpObj_eq_of_eqOnOpen`};
  `lem:hom_additivity_over_product` → `thm:rigidity_lemma` → … → leaf lemmas
  (`lem:eq_comp_of_isAffine_of_properIntegral`, `lem:isIntegral_of_retract_of_integral`);
  `def:gaTranslationP1` → `def:genus0_base_objects`. No back-edges. All `\uses` labels resolve
  to real `\label`s (cross-chapter `thm:GrpObj_eq_of_eqOnOpen` → `Rigidity.tex`; `def:genus` →
  `Genus.tex`).
- **Demoted blocks cleanly off-path.** `lem:hom_Ga_to_av_trivial`, `lem:hom_from_Ga_trivial`,
  `lem:av_regular_map_is_hom`, `lem:rational_map_to_av_extends` (Thm 3.2 / Lemma 3.3 codim-1
  gap) are NOT in the `\uses` closure of `prop:morphism_P1_to_AV_constant` or the headline.
  Confirmed by inspecting L1190/L1212 (`\uses` of the prop names none of them). The riskiest
  sub-build (Lemma 3.3 Weil-divisor gap, `rmk:thm32_codim1_mathlib_gap`) is now correctly
  confined to Route-A and is no longer on the genus-0 critical path.
- **No laundering beyond the known infra bug.** The rigidity chain (`thm:rigidity_lemma` …
  leaves) is sorry-free/axiom-clean since iter-162. The only un-proven critical-path items are
  (i) the [expected] scaffold defs and (ii) `morphism_P1_to_grpScheme_const` itself (the new
  prover target) and `genusZero_curve_iso_P1` (acknowledged hard sub-build,
  `rmk:genusZero_iso_subbuild`). The false proof-`\leanok` on the 3 scaffold props is the known
  `sync_leanok` keyword-prefix bug — per directive, not mine to fix and not gate-blocking.

## Top-level summaries

### Lean difficulty quality
- `AbelianVarietyRigidity.tex` / `\lean{morphism_P1_to_grpScheme_const}`: **soon, NOT
  gate-blocking.** The new scaling-shortcut proof requires the *concrete* ℙ¹
  (`ProjectiveLineBar`) so that σ_× (`gmScalingP1`) and the dense `𝔾_m ⊂ ℙ¹` are available. But
  the current Lean scaffold (`AbelianVarietyRigidity.lean:919`) takes an **abstract** genus-0
  proxy `(P1 : Over (Spec k̄)) [SmoothOfRelativeDimension 1] [IsProper] [GeometricallyIrreducible]
  (genus P1 = 0)` — on which the scaling action cannot be formed. The blueprint itself is
  internally consistent (it proves the concrete-ℙ¹ statement), so this is a scaffold-signature
  refinement for the prover, not a blueprint defect. **Recommended prover instruction to relay:**
  specialise `morphism_P1_to_grpScheme_const` to `P1 := ProjectiveLineBar` (drop the abstract
  proxy), and have `rigidity_genus0_curve_to_grpScheme` transport the abstract curve `C` to the
  concrete ℙ¹ via `genusZero_curve_iso_P1` before applying it. The `\lean{...}` hint names a real
  declaration with a sound target type; flagging only so the prover does not attempt the σ_×
  construction against the abstract proxy.

## Per-chapter

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Fast-path gate CLEARS — scaling-shortcut proof of `prop:morphism_P1_to_AV_constant` is
    prover-ready, math verified end-to-end (see gate Q1).
  - `def:genus0_base_objects` / `def:gaTranslationP1` carry the required concrete chartwise
    total-morphism computation; [expected] Lean infra acceptable as definition scaffolds.
  - SOON note (does NOT block): the prover must use the concrete `ProjectiveLineBar` for σ_×;
    the current abstract-proxy scaffold signature of `morphism_P1_to_grpScheme_const` should be
    specialised (see "Lean difficulty quality" above). Blueprint math is sound regardless.
  - Citation discipline spot-checked OK on the active-path blocks: `thm:rigidity_lemma` /
    `lem:rigidity_eqOn_*` carry verbatim Mumford Ch.II §4 p.43 quotes with
    `(read from references/mumford-abelian-varieties.pdf …)`; `lem:hom_additivity_over_product`
    carries the Milne Cor 1.5 verbatim quote; project-bespoke assembly blocks
    (`lem:morphism_eq_of_eqAt_closedPoints`, `lem:eq_comp_of_isAffine_of_properIntegral`,
    `lem:isIntegral_of_retract_of_integral`) correctly omit source lines and say so. The
    iter-164 NOTE on `lem:hom_Ga_to_av_trivial` (quotes reproduced from verified in-tree copy,
    not re-rendered this session because the host lacks `pdftoppm`) is on a DEMOTED off-path
    block — informational only, not gate-relevant.

### Other chapters (brief status — fast-path scope, not re-audited in depth this pass)

This was an explicit single-chapter fast-path re-review. Per the directive ("no change
expected" elsewhere), the chapters below are reported at prior-verdict level. File mtimes show
only `AbelianVarietyRigidity.tex` (12:52) and `Jacobian.tex` (11:19) were touched this iter.

- `blueprint/src/chapters/Rigidity.tex` — complete + correct (prior). Hosts the proven
  `thm:GrpObj_eq_of_eqOnOpen` consumed by the gate chapter; spot-confirmed `\leanok`.
- `blueprint/src/chapters/Jacobian.tex` — **edited this iter (11:19); not deep-re-audited this
  fast-path.** It is the genusZeroWitness consumer of `thm:rigidity_genus0_curve_to_AV`. Prior
  iter-163 verdict stood; recommend a normal-path re-audit next iter to confirm the consumer
  edges match the re-routed genus-0 chain. Not a blocker for the AVR gate.
- `blueprint/src/chapters/RigidityKbar.tex` — complete + correct (prior; fallback Route-(a)
  artifact, still carries `[CharZero]`). Not on the committed route-(c) path.
- `blueprint/src/chapters/Genus.tex` — complete + correct (prior). Hosts `def:genus` consumed
  by `prop:genusZero_curve_iso_P1`.
- `blueprint/src/chapters/Differentials.tex` — prior verdict stands; off the committed path.
- `blueprint/src/chapters/Cohomology_MayerVietoris.tex` — prior verdict stands.
- `blueprint/src/chapters/Cohomology_SheafCompose.tex` — prior verdict stands.
- `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` — prior verdict stands.
- `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` — prior verdict stands.
- `blueprint/src/chapters/AbelJacobi.tex` — prior verdict stands.
- `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` — prior verdict stands.

## Severity summary

- **must-fix-this-iter**: NONE for `AbelianVarietyRigidity.tex`. The fast-path gate clears.
- **soon**: 1 — the `morphism_P1_to_grpScheme_const` abstract-proxy→concrete-ℙ¹ signature
  refinement (prover instruction to relay; blueprint math sound, does not block the gate).
- **informational**: `Jacobian.tex` was edited this iter and merits a normal-path re-audit next
  iteration to confirm its consumer edges against the re-routed genus-0 chain.

No unstarted-phase proposals this dispatch (fast-path scope; the committed route-(c) phase is
covered by `AbelianVarietyRigidity.tex`).

Overall verdict: `AbelianVarietyRigidity.tex` is `complete: true` + `correct: true` with no
must-fix — the 𝔾_m-scaling-shortcut proof of `prop:morphism_P1_to_AV_constant` is prover-ready,
math verified end-to-end, `\uses` forward-acyclic with demoted blocks cleanly off the
genus-0 critical path; fast-path gate CLEARS for putting `AbelianVarietyRigidity.lean` into this
iter's prover objectives, with one non-blocking prover instruction (specialise to the concrete
`ProjectiveLineBar`).
