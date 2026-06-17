# AlgebraicJacobian/AbelianVarietyRigidity.lean

## Summary

- **Added axiom-clean:** 2 declarations
  - `AlgebraicGeometry.Proj.awayι_preimage_basicOpen_self` (line ~189)
  - `AlgebraicGeometry.Proj.awayι_eq_specMap_fromSpec` (line ~199)
- **Blocked on:** `kbarChart1Ring_specMap_fac` (line 326) — still carries a `sorry` on
  the residual `appTop(Spec.map kbarChart1Ring) = appTop(iotaGm_r_1)` ring-map identity.
- **Blocked on:** `iotaGm_chart1_appIso_eval` (line ~534) — same residual content modulo
  iso-chain functoriality.
- **Sorry count in this file**: 4 before → 4 after (no net delta in `sorry` count, but
  +2 axiom-clean reusable supplement lemmas at the Mathlib-graded-ring abstraction level).

## Session summary

The iter-196 Lane E directive was to close the two Lane E `sorry`s at lines 273 and 481
(now relocated to 326 and ~534 after the supplement insertion) via the blueprint-pinned
analogist recipe `lane-e-proj-appiso-pivot` (verdict ANALOGUE_FOUND, recipe in blueprint
`chapters/AbelianVarietyRigidity.tex:1265-1553`).

The blueprint specified three substrate lemmas to land:
1. `Proj.awayι_isoSpec_compat` — bridge `awayι` to `IsAffineOpen.fromSpec`.
2. `Proj.awayι_app_basicOpen` — section-level formula (port of `IsAffineOpen.fromSpec_app_self`).
3. `Proj.awayι_appIso_top_inv_apply_isLocElem` — point-value via `Iso.eq_inv_apply` + `awayToSection_apply`.

**This iteration landed (1) axiom-clean** as `Proj.awayι_eq_specMap_fromSpec` and the
auxiliary `Proj.awayι_preimage_basicOpen_self`. **(2) and (3) did NOT close** due to
the dependent-motive issue described below.

## Proj.awayι_preimage_basicOpen_self (new, line ~189)
- **Approach:** Two-step rewrite: `← Proj.opensRange_awayι` then `Scheme.Hom.preimage_opensRange`.
- **Result:** RESOLVED — axiom-clean. `lean_verify` confirms `{propext, Classical.choice, Quot.sound}`.

## Proj.awayι_eq_specMap_fromSpec (new, line ~199)
- **Statement:** `Proj.awayι 𝒜 f f_deg hm = Spec.map (basicOpenIsoAway 𝒜 f f_deg hm).inv ≫
  (isAffineOpen_basicOpen 𝒜 f f_deg hm).fromSpec`.
- **Approach:** Unfold `Proj.awayι` and `IsAffineOpen.fromSpec` to expose
  `basicOpenIsoSpec.inv ≫ ι` vs `Spec.map(basicOpenIsoAway.inv) ≫ isoSpec.inv ≫ ι`. Cancel
  the trailing `ι` via `congr 1`. Repackage the RHS of the remaining iso equation as
  `(isoSpec ≪≫ Spec.mapIso basicOpenIsoAway.op).inv` so we can apply `Iso.ext` on the
  forward direction, where the chain
  `basicOpenIsoSpec.hom = basicOpenToSpec = toSpecΓ ≫ Spec.map(awayToSection)`
  and `isoSpec.hom = toSpecΓ` makes the equation `rfl` after rewriting via
  `Proj.basicOpenIsoSpec_hom`, `Proj.basicOpenToSpec`, `Iso.trans_hom`,
  `IsAffineOpen.isoSpec_hom`, `Functor.mapIso_hom`.
- **Result:** RESOLVED — axiom-clean. `lean_verify` confirms `{propext, Classical.choice, Quot.sound}`.

## Proj.awayι_app_basicOpen (NOT ADDED)
- **Approach 1:** `conv_lhs => rw [Proj.awayι_eq_specMap_fromSpec ...]` — FAILED.
  The `rw` motive is dependent: `Scheme.Hom.app f V` has codomain `Γ(X, f ⁻¹ᵁ V)`, so
  changing `f` from `awayι` to `Spec.map(...) ≫ fromSpec` makes the type-checker fail
  because the codomain `awayι ⁻¹ᵁ D₊(f)` changes shape (even though both sides equal `⊤`).
- **Approach 2:** `congrArg (·.app (basicOpen 𝒜 f)) (Proj.awayι_eq_specMap_fromSpec ...)` —
  FAILED with the same dependent-typing issue at the `congrArg` motive elaboration.
- **Approach 3:** Direct `change ((basicOpenIsoSpec.inv ≫ ι).app _ = _)` to unfold `awayι`
  syntactically, then `Scheme.Hom.comp_app` to split. The first factor `ι.app(basicOpen 𝒜 f)`
  evaluates via `Scheme.Opens.ι_app` to `presheaf.map (homOfLE _).op`. The second factor
  `basicOpenIsoSpec.inv.app (ι ⁻¹ᵁ basicOpen 𝒜 f)` needs to be evaluated; here `ι ⁻¹ᵁ basicOpen 𝒜 f = ⊤`
  (by `Scheme.Opens.ι_preimage_self`), but `basicOpenIsoSpec.inv.app ⊤` requires
  inverting the `basicOpenToSpec.app ⊤` formula from `Proj.basicOpenToSpec_app_top`.
  Concretely: need `Scheme.inv_app` + `Proj.basicOpenIsoSpec_hom` + `Proj.basicOpenToSpec`
  combined with `(asIso basicOpenToSpec).inv = inv basicOpenToSpec`. This last step requires
  careful handling of the iso construction. PARTIAL — substantive remainder ~5-15 LOC.
- **Next step:** Need an `appTop`-level identity. Specifically, build a helper
  `Proj.basicOpenIsoSpec_inv_app_top :
    (Proj.basicOpenIsoSpec 𝒜 f f_deg hm).inv.app ⊤ =
      (Proj.basicOpen 𝒜 f).topIso.hom ≫
      (Proj.basicOpenIsoAway 𝒜 f f_deg hm).inv ≫
      (Scheme.ΓSpecIso _).inv`
  via `Scheme.inv_app` + `basicOpenToSpec_app_top` + the iso inversion. ~5-15 LOC.
  This is the missing piece. Plan for iter-197.

## Proj.awayι_appIso_top_inv_apply_isLocElem (NOT ADDED)
- **Approach:** Blueprint recipe step (ii) — `Scheme.Hom.appIso_hom` + `Iso.eq_inv_apply` +
  `awayToSection_apply`. Cannot be tried until `Proj.awayι_app_basicOpen` lands (it is
  the substrate primitive).
- **Result:** NOT ADDED.

## kbarChart1Ring_specMap_fac line 326 sorry (NOT CLOSED)
- **Approach 1:** Use the iter-194 structural reduction `rw [← iotaGm_r_1_fac]; congr 1; refine ext_of_isAffine` — already in the proof body, reducing the goal to
  `appTop(Spec.map(kbarChart1Ring)) = appTop(iotaGm_r_1)`. The residual sorry remains.
- **Approach 2:** Bypass `iotaGm_r_1` entirely by using `Proj.awayι_eq_specMap_fromSpec`
  on the original goal `Spec.map(kbarChart1Ring) ≫ awayι X_1 = onePt.left`. This rewrites
  to `Spec.map(kbarChart1Ring) ≫ Spec.map(basicOpenIsoAway.inv) ≫ fromSpec = onePt.left`,
  i.e., `Spec.map(basicOpenIsoAway.inv ≫ kbarChart1Ring) ≫ fromSpec = onePt.left`. This
  needs a characterization of `onePt.left` factoring through `fromSpec`. The natural
  characterization is `onePt.left = (something) ≫ fromSpec` via the universal property of
  `fromSpec` (as an open immersion). PARTIAL — substantive remainder still ~10-20 LOC.
- **Next step:** With `Proj.awayι_app_basicOpen` landed (per the iter-197 plan above),
  follow the iter-196 blueprint dispatch:
  1. Rewrite RHS using `Proj.awayι_appIso_top_inv_apply_isLocElem`.
  2. Use `ext_of_isAffine` + `awayToSection_apply` to identify both ring maps.
  3. Close via `kbarChart1Ring` definitional unfolding + `MvPolynomial.eval` collapse.

## iotaGm_chart1_appIso_eval line ~534 sorry (NOT CLOSED)
- **Approach:** Same recipe as `kbarChart1Ring_specMap_fac` modulo the iso-chain
  functoriality stages 5–8 in the existing proof body. Pre-requisite: `Proj.awayι_app_basicOpen`.
- **Result:** NOT ADDED.

## Why I stopped

**Real progress:** 2 axiom-clean declarations added.

- `AlgebraicGeometry.Proj.awayι_preimage_basicOpen_self` (line ~189) — supplement that
  combines `Proj.opensRange_awayι` with `Scheme.Hom.preimage_opensRange`. General-purpose
  (graded ring `𝒜 : ℕ → σ`); not project-specific.
- `AlgebraicGeometry.Proj.awayι_eq_specMap_fromSpec` (line ~199) — the bridge between
  `Proj.awayι` and `IsAffineOpen.fromSpec` for the basic open `D₊(f)`. General-purpose
  (graded ring level); the substantive content of step (i) of the iter-195 analogist
  recipe `lane-e-proj-appiso-pivot`.

**Partial progress on Lane E HARD BAR:** Neither of the two Lane E `sorry`s closed.
The infrastructure I added is the FIRST of 3 prerequisite substrate primitives from the
blueprint recipe; the remaining 2 (`Proj.awayι_app_basicOpen` + `Proj.awayι_appIso_top_inv_apply_isLocElem`)
are the load-bearing ones, but were blocked by the dependent-motive issue on
`Scheme.Hom.app` when trying to rewrite via the compat lemma.

**Specific blocker (named):** Proving `Proj.awayι_app_basicOpen` directly via the
compat lemma `Proj.awayι_eq_specMap_fromSpec` fails because `Scheme.Hom.app f U` has
codomain `Γ(X, f ⁻¹ᵁ U)`, so rewriting `f` changes the codomain type. Mathlib has no
`congrArg`-style lemma for `Scheme.Hom.app` that handles this. Workaround: avoid the
rewrite path entirely, build `Proj.basicOpenIsoSpec_inv_app_top` as a fresh helper
(~5-15 LOC, mechanical via `Scheme.inv_app` + `Proj.basicOpenToSpec_app_top`), then
chain through `Scheme.Hom.comp_app` + `Scheme.Opens.ι_app`. This is the recommended
iter-197 path.

**Why not informal agent:** No `DEEPSEEK_API_KEY` / `MOONSHOT_API_KEY` / `OPENROUTER_API_KEY` /
`OPENAI_API_KEY` / `GEMINI_API_KEY` set in env (checked via `env | grep`). Informal agent
unavailable.

## Recommendations for iter-197 plan

1. **Continue Lane E with iter-197 prover dispatch.** The blueprint-pinned recipe still
   applies; the iter-196 supplements (`awayι_preimage_basicOpen_self`,
   `awayι_eq_specMap_fromSpec`) are now in tree and reduce the remaining LOC budget by ~5.
2. **Highest-value next helper:** `Proj.basicOpenIsoSpec_inv_app_top` (~5-15 LOC).
   This unblocks `Proj.awayι_app_basicOpen` via `Scheme.Hom.comp_app` chase. The full
   chain `Proj.awayι → comp_app → ι_app + basicOpenIsoSpec_inv_app_top` then gives the
   target section-level formula without the dependent-motive issue.
3. **Subsequent helper:** `Proj.awayι_appIso_top_inv_apply_isLocElem` (~5-10 LOC) by
   `Scheme.Hom.appIso_inv_app` + `awayToSection_apply` + `awayι_app_basicOpen`.
4. **Consumer dispatches** at line 326 and ~534 (~5-15 LOC each) drop into place.

**Total iter-197 LOC estimate (conditional on the iter-196 supplements landing):**
~25-45 LOC across 2 supplements + 2 consumer closures. Tight scope for a 1-iter dispatch.
