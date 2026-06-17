# Iter-226 objectives — detail

## Lane TS — `Picard/TensorObjSubstrate.lean` — d.2-free descent re-route [mathlib-build]

Goal: build the three descent bridges and assemble `exists_tensorObj_inverse` (project sorry 80→79,
the first genuine downward mover since iter-217), WITHOUT re-entering the abandoned d.2 stalk-⊗ build.
Recipe + citations: `analogies/ts226descent.md` (analogist ts226descent, verdict D = d.2-FREE).

### Bottom-up build order

**1. B-connector (cheapest; unblocks everything).**
- Statement: `f : M ⟶ N` of `X.Modules` (`= SheafOfModules X.ringCatSheaf`) that is an isomorphism
  on each open of an open cover of `X` is an isomorphism.
- Route: `CategoryTheory.Sheaf.isLocallyBijective_iff_isIso` (`Sites/LocallyBijective.lean:84`) gives
  `IsLocallyInjective f ∧ IsLocallySurjective f ↔ IsIso f` for `Sheaf J A`; transfer to
  `SheafOfModules` via `isIso_iff_of_reflects_iso _ (SheafOfModules.toSheaf R)`
  (`Sheaf/Localization.lean:44`), using `(forget R).ReflectsIsomorphisms` (`Sheaf.lean:80`).
- Connector to build: "`M.restrict U.ι` iso on an open cover" ⇒ site-level locally-bijective on
  `Opens.grothendieckTopology X`. `[J.WEqualsLocallyBijective AddCommGrp]` + `HasSheafify` already
  hold for this site (file already uses the `W`-machinery).

**2. A-bridge — SheafOfModules morphism descent (~30–60 LOC).**
- Statement: compatible local morphisms `fᵢ : M|_{Uᵢ} ⟶ N|_{Uᵢ}` agreeing on overlaps glue to a
  unique global `f : M ⟶ N` restricting to each `fᵢ`.
- Route: glue the underlying ab-sheaf morphism with `CategoryTheory.Presheaf.IsSheaf.hom`
  (`Sites/SheafHom.lean:207`) / `sheafHomSectionsEquiv` (`:241`), forgetting through
  `SheafOfModules.toSheaf R` (`Sheaf.lean:89`, faithful+additive); promote to 𝒪_X-linear via
  `PresheafOfModules.homMk` — R-linearity `f(r•m)=r•f(m)` is sectionwise, survives gluing (M separated).

**3. C — `dual_isLocallyTrivial` via `(dual M)|_U ≅ dual_{𝒪_U}(M|_U)`.**
- Build the dual-vs-restriction iso by the SAME H1∘H2 recipe as the CLOSED `tensorObj_restrict_iso`
  (`:1822`), substituting `ModuleCat.restrictScalarsEquivalenceOfRingEquiv` (`ChangeOfRings.lean:285`;
  equivalence `:303`, additive `:325`, linear `:335`) for the open-immersion ring iso `f.appIso` to
  carry `Hom(-,-)`/dual across restriction. Then `dual(𝒪_U) ≅ 𝒪_U` + `IsLocallyTrivial L ⇒
  IsLocallyTrivial (dual L)`.

**4. Assemble `exists_tensorObj_inverse` (L1955; the 80→79 mover).**
- `Linv := Scheme.Modules.dual L` (nameable since iter-225).
- On a trivialising open: `L|_U ≅ 𝒪_U ⇒ (dual L)|_U ≅ 𝒪_U` (by C) `⇒ (L ⊗ dual L)|_U ≅ 𝒪_U ⊗ 𝒪_U ≅
  𝒪_U` via `tensorObj_restrict_iso ≪≫ tensorObjIsoOfIso (…) ≪≫ tensorObj_unit_iso` — the EXACT pattern
  at L1920–1925 / `tensorObj_isLocallyTrivial` (`:1912`).
- Glue these canonical local isos to a global `tensorObj L (dual L) ⟶ 𝒪_X` via the A-bridge (check the
  overlap-cocycle agreement — bounded, the `O⊗O ≅ O` left-unitor intertwining `g_{ij}·g_{ij}⁻¹`; NOT
  d.2); conclude it is a global iso via the B-connector. Close the sorry.

### Forbidden / dead ends (analogist ts226 + file history)
- The sheafify-the-presheaf-eval/associator shortcut (`eval = sheafify(internalHomEval)`,
  `associator = sheafify(presheaf associator)`): re-hits the `M◁η`/`η▷P` whiskering = d.2. DEAD END.
- Building / proving / pinning `isLocallyInjective_whiskerLeft_of_W` (L641) — vestigial d.2.
- Sectionwise flatness `∀U, Module.Flat (𝒪_X(U)) (M(U))` — FALSE for line bundles over non-affine opens.
- `addCommGroup_via_tensorObj` (L1981, RPF consumer); `set_option maxHeartbeats`; the 14-site
  `Sheaf.val`→`ObjectProperty.obj` deprecation migration.

### Success bar
- Any of B/A/C landing axiom-clean = real forward progress; full win = `exists_tensorObj_inverse`
  closed (80→79). `lean_verify` each new decl = `{propext, Classical.choice, Quot.sound}`; build GREEN.
- If A/B/C land but assembly needs another iter: hand off the precise remaining step (cocycle/glue) —
  do NOT pin a sorry into a new decl (mathlib-build no-sorry invariant; iter-214 d.1 anti-pattern).

### Ride-along (lvb ts225 minor 1)
- Refresh the now-stale comment in the `exists_tensorObj_inverse` sorry body (L1959–1964) — the dual
  object landed; the remaining block is the sheaf-level evaluation/glue, not the dual. One-line only,
  if the sorry is not closed this iter.
