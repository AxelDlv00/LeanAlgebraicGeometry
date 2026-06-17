# Mathlib Analogist Report

## Mode
api-alignment

## Slug
tosheaf-epi

## Iteration
033

## Question
We need `AlgebraicGeometry.toSheaf_preservesEpimorphisms`: `SheafOfModules.toSheaf R` preserves
epimorphisms, to pass from `Epi g` in `X.Modules` to local section surjectivity via
`Sheaf.isLocallySurjective_iff_epi'`. Decide the cleanest Mathlib-aligned route and whether Mathlib
already supplies it. Resolve the four sub-questions (existing colimit/epi instance? epi↔locally-surjective
bridge for `SheafOfModules`? abelian/balanced + faithful giving it cheaply? how colimits are computed?).

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Is `toSheaf_preservesEpimorphisms` a missed instance or a real build? | NEEDS_MATHLIB_GAP_FILL | informational (upstream gap, not a project failure) |

**Bottom line: it is a genuine — but bounded, single-lemma — build, not a missed one-liner.**
Mathlib ships the *limit* side (`PreservesFiniteLimits (toSheaf R)`) but **not** the colimit/epi
side, and the limit-side proof provably does not dualize. All dependencies for the build already
exist in Mathlib.

## Answers to the four sub-questions

1. **Existing `PreservesEpimorphisms` / `PreservesFiniteColimits` / `PreservesColimits` for
   `toSheaf`?** No. Exhaustive grep of `Mathlib/Algebra/Category/ModuleCat/` finds only the limit
   side: `PreservesFiniteLimits (toSheaf R)` (`Sheaf/Limits.lean:118`), `ReflectsFiniteLimits`,
   `ReflectsIsomorphisms`. No colimit/epi/exactness instance for `toSheaf` anywhere in Mathlib.
   **Confirmed gap.**

2. **`epi ↔ isLocallySurjective` for `SheafOfModules`?** No module-level characterization exists.
   Mathlib has, on the abelian-sheaf side, `Sheaf.epi_of_isLocallySurjective` and
   `Sheaf.isLocallySurjective_iff_epi'` (`…/Sites/EpiMono.lean:103,123`, needs `[Balanced (Sheaf J A)]`,
   `HasSheafify`, `HasSheafCompose`). There **is** a `PresheafOfModules.IsLocallySurjective`
   abbrev (`…/ModuleCat/Sheaf.lean:190`) = local surjectivity of the underlying `toPresheaf` map,
   and `((toSheaf R).map f).hom = (forget ⋙ toPresheaf).map f` (`toSheaf_map_hom`), so
   `IsLocallySurjective (toSheaf g)` is definitionally the module-level local surjectivity. But the
   missing arrow is exactly `Epi g (in SheafOfModules) ⟹ IsLocallySurjective`, which is **not**
   in Mathlib — it is the content of `toSheaf` preserving epis.

3. **Abelian/balanced + faithful giving it cheaply?** `SheafOfModules R` **is** abelian
   (`Sheaf/Abelian.lean:40`, via `abelianOfAdjunction` over `sheafificationAdjunction (𝟙 R.obj)`),
   hence balanced; `Sheaf J AddCommGrpCat` is abelian/balanced too. But `toSheaf` being
   additive + faithful + **left**-exact (`PreservesFiniteLimits`) does **not** give epi-preservation:
   faithful functors *reflect* epis, not preserve them, and left-exact ≠ right-exact. The cheap
   abelian route to epi-preservation is `Abelian.preservesEpimorphisms_of_map_exact`
   (`…/Abelian/Exact.lean:255`), but its hypothesis (maps exact → exact) is equivalent work to the
   colimit build below.

4. **How are colimits computed in `SheafOfModules R`?** As the **sheafification of the
   presheaf-of-modules colimit**: `Sheaf/Colimits.lean:32-38` builds `HasColimitsOfShape` from
   `F ≅ (F ⋙ forget R) ⋙ sheafification (𝟙 R.obj)` (counit iso) and `hasColimit_of_iso`. The
   coherence iso the directive asked about **exists**:
   `PresheafOfModules.sheafificationCompToSheaf (𝟙 R.obj) : sheafification (𝟙 R.obj) ⋙ toSheaf R ≅
   toPresheaf R.obj ⋙ presheafToSheaf J AddCommGrpCat` (`…/ModuleCat/Presheaf/Sheafification.lean`).
   This square — **not** a `forget`-based factorization — is the spine of the build.

## Why all four prover attempts correctly fail (structural confirmation)

- (1) `preservesEpimorphisms_of_preserves_shortExact_right` is circular: it needs `Epi (toSheaf g)`.
- (2) `isLocallySurjective_iff_epi'` reduces to the missing `Epi g ⟹ IsLocallySurjective (toSheaf g)`;
  its `[Balanced (Sheaf J A)]` fails under `rw` — solvable later in term mode, but the real gap is epi.
- (3) stalk route needs stalk-exactness of the SES — same content.
- (4) `toSheaf ≅ (forget ⋙ toPresheaf) ⋙ presheafToSheaf` is true but useless: **`forget` is a
  RIGHT adjoint** (right adjoint of `sheafification (𝟙 R.obj)`), so the composite does not preserve
  colimits/epis. This is the exact wall, and it is also why the limit-side proof
  (`Limits.lean:118`, which uses `preservesFiniteLimits_of_reflects_of_preserves` precisely because
  `forget` *preserves limits* as a right adjoint) **does not dualize** to colimits.

## Ranked routes (all dependencies verified present in Mathlib)

**Route A — RECOMMENDED. Build `PreservesFiniteColimits (toSheaf R)`, then epi is a corollary.**
The missing dual of `Limits.lean`, routed through the sheafification square. Minimal lemma chain
(`L := PresheafOfModules.sheafification (𝟙 R.obj)`):
  1. `sheafificationCompToSheaf (𝟙 R.obj)`: `L ⋙ toSheaf ≅ toPresheaf R.obj ⋙ presheafToSheaf` — **exists**.
  2. `PreservesFiniteColimits (toPresheaf R.obj)` — **exists** (`Presheaf/Colimits.lean:157`).
  3. `presheafToSheaf` is left adjoint (`sheafificationAdjunction`) ⇒ preserves colimits
     (`Adjunction.leftAdjoint_preservesColimits`, `Adjunction/Limits.lean:88`).
     ⇒ `L ⋙ toSheaf` preserves finite colimits (1∘2∘3).
  4. `L` is left adjoint ⇒ `PreservesColimits L`; counit `(sheafificationAdjunction (𝟙)).counit`
     is iso (used `Abelian.lean:42`, `Colimits.lean:37`).
  5. Per-diagram: `F ≅ (F ⋙ forget) ⋙ L` (`Colimits.lean:35`) ⇒ `toSheaf` carries `colimit F` to a
     colimit cocone; package via `preservesColimit_of_natIso` (`Preserves/Basic.lean:280`) /
     `preservesFiniteColimits_of_natIso` (`Preserves/Finite.lean:248`).
  6. `instance : PreservesEpimorphisms (toSheaf R)` via
     `preservesEpimorphisms_of_preservesColimitsOfShape` (needs `PreservesColimitsOfShape WalkingSpan`,
     subsumed by finite colimits) — `Limits/Constructions/EpiMono.lean:62`.
  Hypotheses (available in the scheme/`X.Modules` setting): `HasWeakSheafify J AddCommGrpCat` (or
  `HasSheafify`) + `J.WEqualsLocallyBijective AddCommGrpCat`. Estimated ~80–150 LOC, one file/section.
  Reusable (right-exactness) and upstreamable to Mathlib.

**Route B — exactness.** Prove `toSheaf` maps short exact → exact, then
`Abelian.preservesEpimorphisms_of_map_exact` (`Abelian/Exact.lean:255`). Same cokernel-preservation
content as Route A, less reusable; not recommended over A.

**Route C — localization transfer.** `L.IsLocalization (J.W.inverseImage (toPresheaf R₀))` exists
(`Sheaf/Localization.lean:48`), but `Mathlib/CategoryTheory/Localization/` ships **no**
colimit-preservation transfer lemma. No shortcut today.

## Downstream wiring (after Route A lands)
`Epi g` (in `SheafOfModules R` / `X.Modules`) → `Epi (toSheaf g)` (new instance) →
`IsLocallySurjective (toSheaf g)` via `(Sheaf.isLocallySurjective_iff_epi' _).mpr inferInstance`
(term mode, to avoid the `rw`-time `Balanced (Sheaf J A)` synthesis failure). The
`Balanced (Sheaf J AddCommGrpCat)` instance follows from its abelian structure.

## Informational
- This `PreservesFiniteColimits (toSheaf R)` is a clean Mathlib gap (the dual of an existing file)
  and a good candidate for an upstream PR; building it project-locally is fully justified.
- No parallel/copy-API risk here: the project should build the *exact* Mathlib-shaped object
  (`PreservesFiniteColimits (toSheaf R)` + the auto `PreservesEpimorphisms` instance), not a
  bespoke `IsLocallySurjective`-only lemma, so downstream code composes with Mathlib's sheaf API.

## Persistent file
- `analogies/tosheaf-epi.md` — rationale, crux (limit proof does not dualize), and the Route-A
  lemma chain captured for future iters.

Overall verdict: NEEDS_MATHLIB_GAP_FILL — not a missed instance; build `PreservesFiniteColimits
(toSheaf R)` via the sheafification square (Route A), from which `toSheaf_preservesEpimorphisms` is
immediate.
