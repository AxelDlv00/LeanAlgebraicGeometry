# AlgebraicJacobian/Picard/GrassmannianQuot.lean

## Summary

**PRIMARY OBJECTIVE COMPLETE — `Grassmannian.functor` fully DROPPED, axiom-clean, build GREEN.**

Sorry count (this file): **6 → 4**. Closed the two functoriality-blocking sorries
(`pullbackObjUnitToUnit_comp` and `functor.map_comp`), which drops `functor` entirely.

- **Closed sorries:**
  - `AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp` (the documented multi-iter keystone)
  - `AlgebraicGeometry.Grassmannian.functor` `map_comp` field
- **New axiom-clean declarations added (both proved, no sorry):**
  - `AlgebraicGeometry.Scheme.Modules.homEquiv_conjugateEquiv_app` — general mate/conjugate
    compatibility of `Adjunction.homEquiv` (reusable category-theory helper).
  - `AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_comp` — composite free-pullback coherence
    (analogue of the existing `pullbackFreeIso_id`).
- **Axiom check** (`lean_verify`): `functor`, `pullbackObjUnitToUnit_comp`, `pullbackFreeIso_comp`
  all use only `propext, Classical.choice, Quot.sound` — NO `sorry`, NO new axioms.
  (The `opaque` warning at L611 is the word "OPAQUE" in a comment, not a declaration.)
- **Build:** `lake build AlgebraicJacobian.Picard.GrassmannianQuot` → *Build completed successfully*.

- **Still open (all ride on `Scheme.Modules.glue`, NOT attempted this iter):**
  - `Scheme.Modules.glue` (L245) — body sorry.
  - `Grassmannian.universalQuotient` (L346), `tautologicalQuotient` (L354),
    `represents` (L843) — each documented "rides on `glue`".

Adjacent sorries beyond the assigned target: investigated `glue` (see "Why I stopped"); did not
start its body — it is a separate large from-scratch construction the planner flagged for possible
blueprint expansion.

## pullbackObjUnitToUnit_comp (the keystone)

### Approach (RESOLVED)
Transpose the whole equation under the composite pullback–pushforward adjunction (`apply
(comp.homEquiv).injective`), then:
1. **LHS** collapses via a new helper `homEquiv_conjugateEquiv_app adj₁ adj₂ α f :
   `adj₂.homEquiv (α.app c ≫ f) = adj₁.homEquiv f ≫ (conjugateEquiv adj₁ adj₂ α).app d`,
   used **term-mode via `refine hL.trans ?_`** so the opaque `pullbackComp` matches up to defeq
   (syntactic `rw` does NOT match it).
2. The conjugate of `(pullbackComp b a).hom` is `(pushforwardComp b a).inv`, obtained from
   `Scheme.Modules.conjugateEquiv_pullbackComp_inv` + `CategoryTheory.conjugateEquiv_comm` +
   `Iso.hom_comp_eq_id`.
3. **RHS** computed by `comp_homEquiv` + `homEquiv_naturality_left/right` +
   `pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit`.
4. Final section-level identity (`uTPU(b≫a) ≫ pushforwardComp.inv.app = uTPU a ≫ pushforward a (uTPU b)`)
   is **`rfl`** (`pushforwardComp_inv_app_app = 𝟙`, `unitToPushforwardObjUnit` sections = ring-hom app,
   `(b≫a)⁻¹U = b⁻¹(a⁻¹U)`).

### Key tactical findings (IMPORTANT for the diamond)
- **`rw` systematically fails to locate visibly-present right-associated sub-composites** in this
  file's category context (even for *generic* categories in the helper, and even `← Category.assoc`
  on `a ≫ b ≫ c`). Workarounds that DO work:
  - **Pure term-mode `calc` / nested `.trans`** with explicit `Category.assoc _ _ _`,
    `CategoryTheory.whisker_eq`, `CategoryTheory.eq_whisker`, `congrArg`.
  - For a stubborn `X = X` left by a `rw` chain (defeq-but-not-syntactic): append a bare **`rfl`**.
  - `set` of a local abbreviation introduces metavar-unification conflicts (`?m := ιi` vs assigned
    `ιFree i`) — **avoid `set`; inline the term**.
- `pullbackFreeIso φ I .hom` vs `pullbackObjFreeIso φ.toRingCatSheafHom I .hom` are defeq but block
  `congrArg`; restate the cofan-comparison `key_*` lemmas with explicit `pullbackFreeIso` types.
- The `homEquiv_unit`/`pbuu` lemmas are `SheafOfModules`-level; the conjugate lemma is
  `Scheme.Modules`-level. Using **Scheme-level adjunctions** in the proof + bridging the
  `pbuu`-homEquiv lemmas by *explicitly supplied* `φ` argument keeps both happy.

## pullbackFreeIso_comp

### Approach (RESOLVED)
Mirror `pullbackFreeIso_id`: `Cofan.IsColimit.hom_ext` over the free cofan (`free = ∐ unit`),
functor `pullback a ⋙ pullback b`; per-injection reduce by `pullbackComp.hom` naturality +
`pullback_map_ιFree_comp_pullbackObjFreeIso_hom` to `pullbackObjUnitToUnit_comp` whiskered by
`ιFree i`. Entirely term-mode `calc`. **Gotcha:** each pullback shifts the base ring sheaf
`Tx ↝ Ty ↝ Tz`, so the trailing `ιFree` indices differ (`ιFree (R := Tx/Ty/Tz)`) — getting these
wrong gives "identical-looking `X = X`" type mismatches.

## functor.map_comp

### Approach (RESOLVED)
After the existing `change` + `pullbackComp.inv.naturality` reduction, the goal whiskers off
`≫ (pullback f ⋙ pullback g).map x.q` to the inverse-form free coherence `hstar`:
`pfba.inv ≫ pullbackComp.inv.app free = pfb.inv ≫ (pullback g).map pfa.inv`,
proved from `pullbackFreeIso_comp` by `rw [← cancel_epi (pullbackComp.hom.app free ≫ pfba.hom)]`
then `trans 𝟙` (both legs telescope; the second via `rw [hH]`). Then a term-mode `.trans` chain
(`Category.assoc`, `congrArg`, `map_comp`) refolds the RHS into `(rqPullback ... ).q`.

## Why I stopped

**Real progress — closed 2 sorries + added 2 axiom-clean helpers; `functor` DROPPED.**
This was the lane's PRIMARY (make-or-break) objective and it is fully done and verified
(`lean_verify` clean, `lake build` GREEN). The keystone `pullbackObjUnitToUnit_comp` — open and
documented as "the sole open obstacle" across many prior iterations — is closed.

For the SECONDARY objective `Scheme.Modules.glue`: I investigated it but did **not** start the body.
`glue` produces a `D.glued.Modules` (a `SheafOfModules` on the glued scheme) by **descent of sheaves
of modules along a `Scheme.GlueData`** — a from-scratch construction with **no Mathlib turn-key
support** (confirmed; `existsUnique_gluing'` is the section-gluing primitive, `overRestrictPullbackIso`
the chart-restriction bridge, both present, but assembling the presheaf-of-modules + sheaf condition
+ transition gluing is a large multi-hundred-line build). The supporting infrastructure
(`pullbackBaseChangeTransport`, `glueData_bridge_src/mid/tgt`, the C1/C2 cocycle hypotheses) is
already in place and proven; only the descent body remains. The planner's standing guidance is to
**blueprint-expand `glue`'s module-descent sub-pieces if it stays stuck** — that is the right next
step rather than a speculative partial body. `universalQuotient`/`tautologicalQuotient`/`represents`
all ride on `glue`.

### Concrete next step (for `glue`)
Blueprint-expand the descent: (1) the glued presheaf of modules `Γ(glued-M, V) := { (sᵢ) ∈ ∏ Γ(Mᵢ,
fᵢ⁻¹V) | g_ij identifies overlaps }` via `existsUnique_gluing'` on the open cover `{ιᵢ : Uᵢ ↪ glued}`;
(2) the `O_glued`-module structure; (3) the sheaf condition. Then the C2 hypothesis (already
well-typed via the `glueData_bridge_*` + `pullbackBaseChangeTransport` scaffolding) feeds the cocycle.

## Blueprint markers (for review agent)
Ready for `\leanok` (now proof-closed, no sorry): `lem:gr_pullbackObjUnitToUnit_comp`,
`def:grassmannian_functor`, `lem:gr_pullbackFreeIso_id` (already), and the new
`pullbackFreeIso_comp` / `homEquiv_conjugateEquiv_app` (no blueprint label yet — plan agent may add
`lem:gr_pullbackFreeIso_comp` / a mate-compatibility entry).
