# Blueprint Writer Report

## Slug
avr-lane-e-recipe

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## LOC delta
+289 LOC (2367 → 2656).

## Changes Made
- **Added subsection** `\subsection*{Iter-195 analogist recipe --- \(\mathtt{Proj.awayι\_app\_basicOpen}\) port (Lane E close)}`
  inserted immediately after the proof body of `lem:iotaGm_chart1_appIso_eval`
  (former line 1264) and before `lem:projlinebar_isReduced`. The subsection
  is the iter-196 progress-critic's requested "explicit Lean API
  specification in the blueprint" for the Lane E chart-1 close.
- **Added lemma** `lem:awayi_app_basicOpen` /
  `\lean{AlgebraicGeometry.Proj.awayι_app_basicOpen}` — the
  section-level closed-form formula for `(Proj.awayι 𝒜 f f_deg hm).app
  (Proj.basicOpen 𝒜 f)` as `basicOpenIsoAway.inv ≫ ΓSpecIso.inv ≫
  presheaf.map(eqToHom(opensRange_awayι)).op`. Port of Mathlib's
  `IsAffineOpen.fromSpec_app_self` (`AffineScheme.lean:560-564`).
  - **Proof sketch added: Y** (four named steps mirroring Mathlib's proof:
    Step 1 unfolds `awayι = basicOpenIsoSpec.inv ≫ basicOpen.ι` and
    applies `Scheme.Hom.comp_app`; Step 2 collapses the open-embedding
    preimage `basicOpen.ι ⁻¹ᵁ basicOpen 𝒜 f = ⊤`; Step 3 invokes
    Mathlib's `basicOpenToSpec_app_top`
    (`ProjectiveSpectrum/Basic.lean:143`) on the inverted
    `basicOpenIsoSpec.inv.app ⊤` factor; Step 4 combines and
    simplifies). LOC estimate \~10-15.
- **Added lemma** `lem:awayi_appIso_top_inv_apply_isLocElem` /
  `\lean{AlgebraicGeometry.Proj.awayι_appIso_top_inv_apply_isLocElem}` —
  the point-value evaluation of `((Proj.awayι).appIso ⊤).inv` on the
  canonical generator `isLocElem`, identifying it with the
  homogeneous-localisation ratio `[X_0/X_1]`. Carries `\uses{lem:awayi_app_basicOpen}`.
  - **Proof sketch added: Y** (three named steps: Step 1 reads off
    `appIso.hom` from `Scheme.Hom.appIso_hom` at
    `OpenImmersion.lean:199`, substituted with
    `lem:awayi_app_basicOpen`; Step 2 flips to the forward direction
    via `Iso.eq_inv_apply`; Step 3 closes by `awayToSection_apply`
    in `ProjectiveSpectrum/Scheme.lean`). LOC estimate \~5-10.
- **Added consumer dispatch paragraph** (no new declaration; prose only)
  documenting how the iter-196 prover uses
  `lem:awayi_appIso_top_inv_apply_isLocElem` to close the existing
  typed sorry at `AlgebraicJacobian/AbelianVarietyRigidity.lean:273`
  in `kbarChart1Ring_specMap_fac`, plus the corollary that the same
  recipe closes the sibling residual at line 481 in
  `iotaGm_chart1_appIso_eval`. Estimated consumer-site close: \~5-10 LOC.

## New `\lean{...}` pins
- `AlgebraicGeometry.Proj.awayι_app_basicOpen`
  (label `lem:awayi_app_basicOpen`)
- `AlgebraicGeometry.Proj.awayι_appIso_top_inv_apply_isLocElem`
  (label `lem:awayi_appIso_top_inv_apply_isLocElem`)

Both pins name NEW Lean declarations that the iter-196 Lane E prover
will land in `AlgebraicJacobian/AbelianVarietyRigidity.lean`.

## Cross-references introduced
- `\uses{lem:awayi_app_basicOpen}` on `lem:awayi_appIso_top_inv_apply_isLocElem`
  — both labels are NEW and defined in the same chapter; the dependency
  ordering (the section-level formula precedes its point-value
  consumer) is preserved in the file order.
- The consumer-dispatch paragraph references the existing
  `\cref{lem:iotaGm_chart1_appIso_eval}` (already defined at file
  position \~1192, well before the new subsection); no new
  cross-reference creates a forward-edge dangling pointer.

## Per-lemma structure summary
- **`lem:awayi_app_basicOpen`**: the substantive identity. Statement is
  the section-level closed-form formula at the basic-open codomain.
  Proof sketch is the verbatim mirror of Mathlib's
  `IsAffineOpen.fromSpec_app_self` proof at
  `Mathlib/AlgebraicGeometry/AffineScheme.lean:560-564` — four named
  steps invoking `Scheme.Hom.comp_app`, `Opens.\iota_app`,
  `Proj.basicOpenIsoSpec_hom`, and
  `Mathlib/.../ProjectiveSpectrum/Basic.lean:143`'s
  `basicOpenToSpec_app_top` (the load-bearing substrate primitive,
  giving the explicit `(ΓSpecIso.hom ≫ awayToSection ≫ topIso.inv)`
  formula for `basicOpenToSpec.app ⊤`).
- **`lem:awayi_appIso_top_inv_apply_isLocElem`**: the point-value
  consumer corollary. Combines `lem:awayi_app_basicOpen` with
  Mathlib's `Scheme.Hom.appIso_hom`
  (`Mathlib/AlgebraicGeometry/OpenImmersion.lean:199`) to expose
  `appIso.hom` in terms of `app(basicOpen)` plus a presheaf-map
  adjustment; then applies `Iso.eq_inv_apply` to reduce the
  inverse-evaluation on `isLocElem` to the structurally cleaner
  forward statement `basicOpenIsoAway.hom(mk_isLocElem) =
  awayι.app(basicOpen)(isLocElem)`. Closed by
  `awayToSection_apply` in
  `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Scheme.lean`.
- **Consumer dispatch (prose only, no new pin)**: three-step recipe
  for the iter-196 prover at
  `AlgebraicJacobian/AbelianVarietyRigidity.lean:273`. Step 1: `simp
  only [Proj.awayι_appIso_top_inv_apply_isLocElem]` rewrites the
  inverse-evaluation on the LHS into the closed form. Step 2:
  `ext_of_isAffine` reduces the morphism equality to ring-map
  equality; `awayToSection_apply` evaluates the RHS. Step 3:
  unfold `kbarChart1Ring` definitionally and collapse the
  `MvPolynomial.eval (fun _ ↦ 1)` adjoint to match the chart-1 ring
  map.

## References consulted
- `analogies/lane-e-proj-appiso-pivot.md` — the iter-195
  `cross-domain-inspiration` analogist recipe; the file from which
  the structural shape of the port was taken (analogue #1,
  `IsAffineOpen.fromSpec_app_self`, ranked lowest porting cost,
  verdict ANALOGUE_FOUND).
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` (lines 200-500) —
  the consumer site (`kbarChart1Ring_specMap_fac` at line 222, with
  typed sorry at line 273) and its sibling
  `iotaGm_chart1_appIso_eval` (line 377+) to confirm the substantive
  residual and check that the recipe targets the exact line-numbers
  named in the directive.

No external textbook references were opened — the new subsection is
project-bespoke (Mathlib API specification + structural port of a
Mathlib lemma to a new context, per the directive). The pre-existing
`% SOURCE QUOTE:` material in earlier blocks (Mumford, Milne) was not
disturbed.

## Macros needed
None. The chapter's existing `\providecommand{\fatsemi}{\mathbin{\,;\,}}`
(line 8) is the only diagrammatic-composition macro used; all other
notation in the new subsection is standard LaTeX / amsmath.

## Reference-retriever dispatches
None. Per the directive, the recipe is a Mathlib-internal port and
required no external source-retrieval.

## Notes for Plan Agent
- The two new pins name declarations the iter-196 Lane E prover must
  land in `AlgebraicJacobian/AbelianVarietyRigidity.lean`. The
  recommended placement is immediately above `kbarChart1Ring_specMap_fac`
  (currently line 222) so the consumer's `simp only [...]` rewrite
  resolves into a declaration in the same file. If the prover prefers
  a shared-helpers home, an extraction into
  `AlgebraicJacobian/Genus0BaseObjects/ProjAwayApp.lean` (or similar)
  would also be appropriate — both lemmas are general-purpose Mathlib
  ports keyed on `Proj.awayι` and have no project-specific
  dependencies beyond the implicit `IsLocalization`-style instances
  for `Away 𝒜 f`.
- The chapter is now \~2656 lines. The blueprint-doctor / planner
  may wish to consider whether the chart-bridge subsection (formerly
  iter-187 mandatory pivot, now extended with the iter-195 analogist
  recipe) is becoming long enough to warrant splitting; this is a
  recommendation for future refactoring, not a directive-blocker.
- The new `\lean{...}` pins do NOT carry `\leanok` markers per the
  writer descriptor (`\leanok` is managed by the deterministic
  `sync_leanok` phase). When the iter-196 prover lands the two new
  declarations, `sync_leanok` will pick them up automatically.

## Strategy-modifying findings
None. The new subsection records a tactical Lean API specification
(a port of named Mathlib substrate lemmas) and a consumer dispatch
recipe; the substantive strategic content (Lane E close via
Proj.appIso evaluation, separated-locus alternative, primary
genus-0 route via Gm-scaling) is unchanged from prior iters. The
directive explicitly forbade altering the iter-187/188/192/193/194
history narrative and that narrative was preserved verbatim.
