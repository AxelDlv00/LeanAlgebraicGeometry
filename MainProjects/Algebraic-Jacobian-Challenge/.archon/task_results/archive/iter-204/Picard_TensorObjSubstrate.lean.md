# Picard/TensorObjSubstrate.lean — iter-204 (Lane TS body fill)

## Summary

- **Inline sorry count**: 4 → 4 (raw count unchanged, but content materially advanced — see below).
- **Sorries closed (the assigned PRIMARY `tensorObj_isLocallyTrivial` body)**: the
  `tensorObj_isLocallyTrivial` sorry is **gone** — its body is now a complete,
  axiom-clean proof that reduces the statement to a **single, sharply-named
  infrastructure ingredient** `tensorObj_restrict_iso`.
- **New fully-closed, axiom-clean reusable helpers** (verified `#print axioms` =
  `[propext, Classical.choice, Quot.sound]`, no `sorryAx`):
  1. `Scheme.Modules.tensorObjIsoOfIso` — `(M ≅ M') → (N ≅ N') → tensorObj M N ≅ tensorObj M' N'`
     (sheafify the presheaf-monoidal `tensorIso` of the underlying presheaf isos).
  2. `Scheme.Modules.tensorObj_unit_iso` — `tensorObj 𝒪_X 𝒪_X ≅ 𝒪_X`
     (presheaf left-unitor `λ_ 𝟙_` under sheafification, then the
     sheafification-adjunction counit iso on the already-sheaf unit).
  3. `Scheme.Modules.restrictIsoUnitOfLE` — refine a trivialisation `M.restrict U.ι ≅ 𝒪_U`
     to any open `W ≤ U`: `M.restrict W.ι ≅ 𝒪_W` (full chart-chase, closed).
- **New named ingredient (partial attempt, not bare sorry)**: `tensorObj_restrict_iso`
  — `(tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)` for an
  open immersion `f`. Body now reduces `restrict` to `pullback` via
  `restrictFunctorIsoPullback`; the residual `sorry` is exactly the
  strong-monoidal-pullback core (see "Why I stopped").
- **Still open** (unchanged): `monoidalCategory` (L150, contamination-guard sorry),
  `exists_tensorObj_inverse` (L300), `addCommGroup_via_tensorObj` (L339).
- **Adjacent sorries attempted beyond assignment**: yes — analysed
  `exists_tensorObj_inverse` and `monoidalCategory` (both found structurally
  gated, see below); attempted `tensorObj_restrict_iso` as a partial block.
- **Axioms**: zero project axioms introduced. Build GREEN
  (`lake build AlgebraicJacobian.Picard.TensorObjSubstrate` → success, 8319 jobs).

## tensorObj_isLocallyTrivial (assigned PRIMARY) — RESOLVED modulo `tensorObj_restrict_iso`

### Approach (blueprint `lem:tensorobj_preserves_locally_trivial`, recipe-backed)
For each point `x`: get trivialising affine opens `U` (for `M`) and `U'` (for `N`)
from `IsLocallyTrivial`; take a common affine `W ⊆ U ⊓ U'` via
`exists_isAffineOpen_mem_and_subset`; refine both trivialisations to `W` with
`restrictIsoUnitOfLE`; then compose
`(M ⊗ N)|_W ≅ M|_W ⊗ N|_W ≅ 𝒪_W ⊗ 𝒪_W ≅ 𝒪_W` via
`tensorObj_restrict_iso ≪≫ tensorObjIsoOfIso _ _ ≪≫ tensorObj_unit_iso`.
The whole assembly compiles; `#print axioms` shows `sorryAx` enters **only**
through `tensorObj_restrict_iso`.

### Key tooling insight (reusable, worth remembering)
The unit-pullback iso `(pullback j).obj 𝒪_U ≅ 𝒪_W` via
`SheafOfModules.pullbackObjUnitToUnit` is the crux of `restrictIsoUnitOfLE`.
Two non-obvious gotchas, both solved:
1. **`homOfLE` vs `resLE`**: building the inclusion `j : W ⟶ U` as
   `X.homOfLE hWU` makes `IsIso (pullbackObjUnitToUnit j.toRingCatSheafHom)`
   **fail** to synthesize; building it as `Scheme.Hom.resLE (𝟙 X) U W hWU'`
   (the idiom used in `LineBundlePullback.IsLocallyTrivial.pullback`) makes it
   **resolve**. Use `resLE`, not `homOfLE`, for unit-pullback chart-chases.
2. **`asIso` doesn't trigger instance search under goal-type pressure**: even
   with `this : IsIso (pullbackObjUnitToUnit …)` in scope, `exact asIso (…)`
   re-infers implicits and misses it. Fix: `haveI hI : IsIso (…) := inferInstance;
   exact @asIso _ _ _ _ _ hI` (pass the instance explicitly, infer `f, X, Y`
   from `hI`; the result is defeq to the goal iso).

## exists_tensorObj_inverse (assigned PRIMARY) — STRUCTURALLY GATED, not attempted in code
The statement is `∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ 𝟙_ (X.Modules))`.
`𝟙_ (X.Modules)` is `MonoidalCategoryStruct.tensorUnit` of the `monoidalCategory`
instance, **whose body is `sorry`** (contamination guard). So the target `𝟙_` is
an opaque `sorry`-derived term: there is no way to construct an explicit iso into
it until `monoidalCategory` supplies a real `tensorUnit` (= `SheafOfModules.unit`).
Additionally the witness `Linv` is the dual `Hom(L, 𝒪_X)`, which needs an
internal-hom sheaf on `SheafOfModules` (also absent in Mathlib). Therefore this
target is gated on `monoidalCategory` (deferred-large) and is **not** profitably
attemptable this iter. Left as documented typed sorry (L300).

## monoidalCategory (STRETCH) — investigated, kept as sorry per contamination guard
Found the relevant Mathlib machinery: `CategoryTheory.Localization.Monoidal`
(transport a monoidal structure along a localization `L : C ⥤ D` given
`[L.IsLocalization W]`, `[W.IsMonoidal]`, and a unit iso). The needed
`[L.IsLocalization W]` **exists**:
`PresheafOfModules.sheafification.IsLocalization (J.W.inverseImage (toPresheaf R₀))`
(`Mathlib.Algebra.Category.ModuleCat.Sheaf.Localization`). The blocker is
`[W.IsMonoidal]` for `W := J.W.inverseImage (toPresheaf R₀)` in the
`PresheafOfModules` category — **NOT present in Mathlib** (the `IsMonoidal`
instances in `Sites/Monoidal.lean` are for `Sheaf J A` with `A` monoidal, i.e.
the cartesian/ambient tensor, NOT the relative `⊗_R` of modules). Even with that,
the transport lands on the type-synonym `LocalizedMonoidal L W ε`, requiring a
further transport to `SheafOfModules R` and a defeq match to the hand-rolled
`tensorObj`. This is the genuine deferred-large piece; kept `:= sorry`.

## Why I stopped

**Verdict: Partial progress (substantial, code-level).**

- **Real progress**: closed 3 reusable axiom-clean helpers
  (`tensorObjIsoOfIso`, `tensorObj_unit_iso`, `restrictIsoUnitOfLE`) and replaced
  the `tensorObj_isLocallyTrivial` sorry with a **complete proof** that reduces it
  to one named ingredient. The affine-cover argument, trivialisation refinement,
  functoriality-of-tensor-on-isos, and unit isomorphism are all genuinely built.
- **Specific remaining blocker** (the lone residual in the `tensorObj_isLocallyTrivial`
  cone): `tensorObj_restrict_iso` — the **strong-monoidal pullback** statement
  `(pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N` for the
  substrate `⊗`. Its body now does the `restrict → pullback` reduction
  (`restrictFunctorIsoPullback`) so only the strong-monoidal core is `sorry`.
  This requires two Mathlib-absent facts: (i) the `PresheafOfModules.Monoidal`
  tensor commutes with the presheaf pullback (sectionwise extension-of-scalars
  `B ⊗_A (P ⊗_A Q) ≅ (B⊗_A P) ⊗_B (B⊗_A Q)`, Stacks 03DM); (ii) sheafification
  commutes with pullback along an open immersion. There is **no monoidal
  structure on `SheafOfModules` in Mathlib**, hence no strong-monoidal pullback.
- **Informal agent**: called (`--provider auto`, MOONSHOT key present) →
  **HTTP 401 Invalid Authentication** (consistent with memory
  `informal-agent-key-invalid`). Unavailable; no suggestion obtained.
- **Hard bar status (honest)**: NOT strictly met. The bar was "≥1 of
  {`tensorObj_isLocallyTrivial`, `exists_tensorObj_inverse`} axiom-clean".
  `tensorObj_isLocallyTrivial`'s cone still contains the `tensorObj_restrict_iso`
  `sorryAx`; `exists_tensorObj_inverse` is gated on `monoidalCategory`'s `𝟙_`.
  However the assigned lemma is now reduced to a single, precisely-characterised
  Mathlib infrastructure gap with three closed supporting helpers.

## Precise missing-ingredient statement (for the plan agent, `mathlib-build` mode)

Closing `tensorObj_restrict_iso` (and thereby `tensorObj_isLocallyTrivial`
axiom-clean) needs ONE of:

1. **`MorphismProperty.IsMonoidal` for the module-sheafification localization**:
   an instance `(J.W.inverseImage (toPresheaf R₀)).IsMonoidal` in
   `PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat)`, after which
   `CategoryTheory.Localization.Monoidal` + the existing
   `sheafification.IsLocalization` instance give a monoidal `SheafOfModules`
   (this ALSO closes `monoidalCategory`, unblocking `exists_tensorObj_inverse`
   and `addCommGroup_via_tensorObj`). This is the highest-leverage single target.
2. A direct project-local pair of lemmas:
   `pullback_tensorObj_iso : (PresheafOfModules.pullback φ).obj (P ⊗ Q) ≅
      (pullback φ).obj P ⊗ (pullback φ).obj Q` (extension of scalars is monoidal),
   plus `sheafification_pullback_comm` (sheafification commutes with pullback
   along an open immersion), assembled with the restrict↔pullback iso.

## Dead-end warnings
- Building the inclusion morphism with `X.homOfLE` blocks
  `IsIso (pullbackObjUnitToUnit …)`; use `Scheme.Hom.resLE (𝟙 X) U W _`.
- `exact asIso (pullbackObjUnitToUnit …)` fails to find the IsIso instance even
  when it is in context; use `haveI hI := inferInstance; exact @asIso _ _ _ _ _ hI`.
- `Sites/Monoidal.lean`'s `IsMonoidal`/`monoidalCategory` are for `Sheaf J A`
  (ambient-monoidal-valued sheaves), NOT for `SheafOfModules` (relative `⊗_R`) —
  do not try to apply them here.
