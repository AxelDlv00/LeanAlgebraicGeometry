# Iter-030 plan — 02KG design fork RESOLVED (cover-agnostic re-parameterization); two lanes: free-Čech re-param + 01I8 global generation

## Entering state (verified)
iter-029's two mathlib-build lanes both landed partial and **stopped on genuine mathematics** (the first such
iter after 6 first-attempt-COMPLETE iters): Lane 1 `AffineSerreVanishing.lean` +3 axiom-clean
(`affine_faces_mem`, `coverOpen_affineOpenCoverOfSpan`, `affine_injective_acyclic` ⊤-case); Lane 2
`QcohTildeSections.lean` +4 axiom-clean (conditional `qcoh_iso_tilde_sections` `[IsIso F.fromTildeΓ]` +
presentation form + 2 accessors). 0 sorries either file. Project sorry = 2 (both frozen/superseded).

Both lanes + both lvb checkers surfaced the same **CRITICAL design fork**: `injective_cech_acyclic` is stated
over `X.OpenCover` (covers ⊤), but `BasisCovSystem.injective_acyclic` is consumed over standard covers of
arbitrary distinguished opens `D(f)`. The ⊤-case `affine_injective_acyclic` cannot discharge the field.

## The decision (D1) — dissolve the fork by re-parameterizing to a cover-agnostic family

**Chosen:** re-parameterize the free Čech resolution machinery (`FreePresheafComplex.lean`) from
`(𝒰 : X.OpenCover)[Finite 𝒰.I₀]` to a raw finite family `{ι}[Finite ι](U : ι → Opens X)`, making
`injective_cech_acyclic` **cover-agnostic** (positive-degree section-Čech vanishing of an injective over ANY
finite family of opens, no covering hypothesis). The `injective_acyclic` field is then discharged DIRECTLY by
the family-form lemma applied to each covering datum `c.2` — no ⊤-restriction, no `X.OpenCover` bridge.

**Why sound (I verified, then both critics confirmed):**
- I checked the Lean: the cover *morphisms* `𝒰.f` are used ONLY in `coverOpen 𝒰 i := (𝒰.f i).opensRange`; the
  augmentation target `coverStructurePresheaf := Limits.image (cechFreeAug)` references no `⊤`/`iSup`/covering
  hypothesis; `cechFreeComplex_quasiIso`'s proof invokes no covering hypothesis. The machinery is intrinsically
  about the indexed family of opens.
- **strategy-critic `iter030` SOUND** gave the clinching stalkwise-exactness proof: at `x`, the augmented free
  complex is the augmented simplicial chain complex of the full simplex on `{i : x∈U_i}` with coefficients
  `O_{X,x}` — contractible (exact) when nonempty, all-zero (exact) when empty; covering only fixes the identity
  of `O_𝒰`, never exactness. The re-parameterized statement is neither vacuous nor false and re-adds no covering
  hypothesis. This is exactly the form 02KG needs over covers of arbitrary `D(f)`.
- **mathlib-analogist `reparam` ALIGN_WITH_MATHLIB**: Mathlib itself indexes Čech by a raw family with no
  covering hypothesis (`CategoryTheory.cechComplexFunctor`, `Limits.FormalCoproduct.cech`); the project's
  section side is already raw-family — the free side is the lone outlier. Keep the bespoke `cechFreeSimplicial`
  (already axiom-clean; rebuilding on `FormalCoproduct.cech` gains nothing). `analogies/reparam.md` persisted.

**Rejected alternative:** realize each `D(f) ≅ Spec R_f` and restrict the injective. Mathematically valid
(restriction along an open immersion preserves injectives), but it resurrects the `j_!`/restriction-of-injectives
apparatus (200–500 LOC) that **Form B was specifically chosen to avoid**. The cover-agnostic re-parameterization
is the cheaper route that keeps the whole edifice consistent. (strategy-critic upheld this rejection.)

**Reversal signal:** if the in-place re-parameterization proves non-mechanical (defeq-carrier friction in
FreePresheafComplex/CechBridge is documented), the prover hands off cleanly (mathlib-build, no sorry); a
follow-up lane finishes the chain. Do NOT switch to the `Spec R_f` route on friction alone.

## The 02KG `surj_of_vanishing` route (scoped, for next iter)
mathlib-analogist confirmed: `ses_cech_h1` (already general over a raw family) + local section surjectivity of
the `O_X`-module epi via `CategoryTheory.Presheaf.IsLocallySurjective` (`isLocallySurjective_iff`), unlocked by
ONE small gap-fill `SheafOfModules.toSheaf.PreservesEpimorphisms` (epi of `O_X`-modules ⇒ epi of underlying
abelian sheaf), then `Sheaf.isLocallySurjective_iff_epi'`; refine the lift cover to affine opens
(`Scheme.isBasis_affineOpens`) to land a standard cover in `Cov`. Blueprinted this iter; built next iter.

## What I did this iter (plan phase)
1. Processed both iter-029 lanes (task ledgers; 02KG fork resolved; lane structure re-sequenced).
2. STRATEGY.md: 02KG row (fork resolved, effort widened to ~4 iters / ~400–650 LOC per strategy-critic),
   stripped iter-stamps from Open questions (strategy-critic format DRIFTED fix), flipped P5a Ext backing
   UNVERIFIED→CONFIRMED (`InjectiveResolution.extEquivCohomologyClass`), added the two new Mathlib gaps
   (`toSheaf.PreservesEpimorphisms`, 01I8 instance).
3. **strategy-critic `iter030` SOUND** (design fork; stalkwise proof) · **progress-critic `iter030` both routes
   UNCLEAR** (fresh; proceed; iter-031 re-run mandatory) · **mathlib-analogist `reparam` ALIGN** (re-param +
   local-surjectivity route, `analogies/reparam.md`).
4. **refactor `root-imports`**: both new files into build root; narrowed QcohTilde `import Mathlib` →
   `Mathlib.AlgebraicGeometry.Modules.Tilde`. Build green (8326 jobs).
5. **blueprint-writer `02kg-reconcile`** (consolidated chapter): repinned `cover_datum_bridge` →
   `coverOpen_affineOpenCoverOfSpan`; recorded family-form `injective_cech_acyclic`; demoted
   `affine_injective_acyclic` to a special case; rewrote `def:affine_cover_system` discharge (direct family
   form, "three proof fields" fix); rewrote `affine_surj_of_vanishing` to the local-surjectivity route (+4
   helper/anchor blocks); added `qcoh_iso_tilde_sections_of_presentation` block + `rem:o1i8_decomposition`
   3-step + accessor bundling. **blueprint-clean `02kg`**: stripped Lean leakage, verified all source quotes
   verbatim. **blueprint-reviewer `iter030`: HARD GATE PASS** (both this-iter lanes formalize-ready).
6. PROGRESS.md (two lanes, scaffold keyword on both path lines for the noop-trap), task ledgers, ARCHON_MEMORY,
   TO_USER, this sidecar, objectives.md.

## This iter's prover lanes (parallel, race-free)
- **Lane A `FreePresheafComplex.lean` [mathlib-build]** — re-parameterize the resolution chain onto family
  versions; keep all `X.OpenCover`-named defs as thin wrappers so **CechBridge stays byte-identical & green**
  (no edit to CechBridge → no race with Lane B). Deliver family `cechFreeComplex_quasiIso`.
- **Lane B `QcohTildeSections.lean` [mathlib-build]** — 01I8 global generation 3-step → instance
  `[IsQuasicoherent F] → IsIso F.fromTildeΓ`; on success the named `qcoh_iso_tilde_sections` upgrades.

## Decisions made
### D1 — re-parameterize to a cover-agnostic family (above). Confirmed SOUND by both critics + my own Lean check.
### D2 — split CechBridge family `injective_cech_acyclic` to NEXT iter (Lane A keeps wrappers, CechBridge
untouched this iter) rather than co-assigning FreePresheafComplex+CechBridge. Why: CechBridge consumes 7+
FreePresheafComplex decls and defines `sectionCechComplexMapOpIso`/`injective_cech_acyclic` itself; co-assigning
risks the downstream prover building against a stale upstream. Wrappers keep the public API stable → zero
regression, clean parallelism with Lane B.

## Prior critique status
- strategy-critic `iter029` (EnoughInjectives connector): addressed (recorded in STRATEGY, build at P5b).
- strategy-critic `iter030` format DRIFTED: addressed in-place this iter (stamps stripped, cells tightened,
  P5a flag flipped, effort widened).

## Open risks / watch (iter-031)
- progress-critic iter-031 MANDATORY: Route A re-param non-dissolution; Route B 01I8 gluing-step recurrence.
- Confirm writer-flagged pins (loogle was down): `Sheaf.isLocallySurjective_iff_epi'`,
  `Scheme.isBasis_affineOpens`, `isIso_fromTildeΓ_of_presentation` full namespace, `toSheaf_preservesEpimorphisms`.
- Fix the spurious `\uses` cycle on `lem:qcoh_iso_tilde_sections` (next blueprint-clean; non-blocking).
