# Analogy: locally-free-sheaf infrastructure for Hartshorne III Ex 6.5 (kernel of epi of locally free is locally free)

## Mode
api-alignment

## Slug
core2

## Iteration
016

## Question
For the four ingredients of "0 → 𝒦 → 𝒢 → ℋ → 0 of O_X-modules, 𝒢,ℋ locally free ⇒ 𝒦 locally free":
(1) free-locus-open, (2) SES with projective/free quotient splits, (3) stalk functor on sheaves of
modules, (4) a "finite locally free"/vector-bundle abstraction to align to instead of the bespoke
`Scheme.Modules.IsLocallyFree`. PROCEED (build bespoke) vs ALIGN (Mathlib idiom exists)?

## Project artifact(s)
- `Foundations.lean:111-114` — `Scheme.Modules.IsLocallyFree` (bespoke predicate, single global finite `I`, `restrictFunctor`-trivialisation).
- `Foundations.lean:1196-1201` — `isLocallyFree_of_iso` (bespoke iso-invariance).
- `Foundations.lean:1203-1215` — `trivialBundle_isLocallyFree` (bespoke: free ⇒ locally free).
- `Foundations.lean:1140-1153` — `evalMap`, `evalKernel` (the M_F kernel bundle).

## Headline correction
The directive states "a prover grep-confirmed Mathlib has NO locally-free-sheaf / vector-bundle
infrastructure on schemes." **THIS IS FALSE.** Mathlib has
`Mathlib.Algebra.Category.ModuleCat.Sheaf.LocallyFree` providing, for an arbitrary site `(C,J)` and
sheaf of rings `R` (hence for `X.Modules = SheafOfModules X.ringCatSheaf`):
- `SheafOfModules.IsLocallyFree (M : SheafOfModules R) : Prop`
- `SheafOfModules.LocalGeneratorsData.IsLocallyFreeData` (witness data) + `IsLocallyFree.mk` / `.exists_isLocallyFreeData`
- `SheafOfModules.LocalGeneratorsData.IsLocallyFreeData.shrink` (refine a trivialising cover — needed by the SES proof)
- `instIsLocallyFreeFree : (SheafOfModules.free I).IsLocallyFree`
- `instIsQuasicoherentOfIsLocallyFree : [M.IsLocallyFree] → M.IsQuasicoherent`
The prover almost certainly grepped for `IsLocallyFree`/`LocallyFree` in `AlgebraicGeometry.*` (where it
is absent) and missed `Algebra.Category.ModuleCat.Sheaf.LocallyFree` (general-site formulation).

## Decisions identified

### Decision 4 (FIRST — load-bearing): the locally-free predicate itself
- **Mathlib idiom**: `SheafOfModules.IsLocallyFree` in `Mathlib.Algebra.Category.ModuleCat.Sheaf.LocallyFree`.
  Built on `M.LocalGeneratorsData` (from `IsFiniteType`) + `IsLocallyFreeData`. General over any site, so
  directly instantiable at `R := X.ringCatSheaf`. Models locally-FINITE-free (per-cover-piece finite rank).
  Sits in the same `ObjectProperty (SheafOfModules R)` ecosystem as `isQuasicoherent` / `isFinitePresentation`.
- **Project's path**: bespoke `Scheme.Modules.IsLocallyFree` — one GLOBAL finite index `I` (constant rank),
  trivialised via `(restrictFunctor U.ι).obj F ≅ free I`. Different shape (single-`I` vs covering-family + local generators).
- **Gap**: divergent-with-cost (a true parallel API; "works" but cannot consume Mathlib's locally-free API).
- **Cost of divergence**:
  1. `trivialBundle_isLocallyFree` re-proves `instIsLocallyFreeFree` (already-spent rework).
  2. `isLocallyFree_of_iso` re-proves iso-invariance Mathlib gives (transport `IsLocallyFreeData`).
  3. Loses `instIsQuasicoherentOfIsLocallyFree` (free quasicoherence) and `IsLocallyFreeData.shrink`
     (cover refinement the 6.5 proof critically needs to find a COMMON trivialising open for 𝒢 and ℋ).
  4. Every downstream consumer (M_L bundle, secant bundles) needs bridge lemmas
     `project.IsLocallyFree ↔ SheafOfModules.IsLocallyFree`, and bridging the two FORMULATIONS
     (restrictFunctor-trivialisation ⇄ `LocalGeneratorsData`) is itself non-trivial.
- **Verdict**: ALIGN_WITH_MATHLIB (must-fix). Replace `Scheme.Modules.IsLocallyFree` with
  `SheafOfModules.IsLocallyFree (R := X.ringCatSheaf)`. If a *constant* global rank is genuinely required
  for Kemeny, define a thin `IsLocallyFreeOfRank k` REFINING Mathlib's predicate (use `Module.rankAtStalk`
  + `Module.isLocallyConstant_rankAtStalk_freeLocus`; constant on connected `X`), never a from-scratch one.
  PORTING RISK: must discharge the `∀ (X:C), (J.over X).HasSheafCompose / HasWeakSheafify /
  WEqualsLocallyBijective` instances for the opens-site of a scheme — verify these resolve for `X.ringCatSheaf`
  (the over-site of opens is again an opens-site; `instIsLocallyFreeFree` is stated generally so Mathlib
  intends them to hold, but the project must confirm synthesis).

### Decision 1: free locus open ("free at a prime ⇒ free on a basic open", Stacks 00NX)
- **Mathlib idiom** (`Mathlib.RingTheory.Spectrum.Prime.FreeLocus`, AFFINE / over a CommRing `R`):
  - `Module.freeLocus R M : Set (PrimeSpectrum R)`; `Module.mem_freeLocus` (∈ ⇔ `M_p` free over `R_p`).
  - `Module.isOpen_freeLocus [Module.FinitePresentation R M] : IsOpen (freeLocus R M)`. ← the openness.
  - `Module.basicOpen_subset_freeLocus_iff [FinitePresentation] : ↑(basicOpen f) ⊆ freeLocus ↔ Projective (Localization.Away f) (LocalizedModule (powers f) M)`. ← "free near p" in basic-open form.
  - `Module.freeLocus_eq_univ_iff [FinitePresentation] : freeLocus = univ ↔ Projective R M`.
  - `Module.freeLocus_eq_univ [Finite][Flat]`; `Module.free_of_flat_of_isLocalRing [IsLocalRing][Finite][Flat] : Free`.
  - `Module.projective_of_localization_maximal` (projective locally at all maximals ⇒ projective, f.p.).
  - `Module.free_of_lTensor_residueField_injective` — clean local-ring criterion: `M→N→P→0` exact, `M,N` f.g., `N` free, `k⊗f` injective ⇒ `P` free.
- **Gap**: identical (Mathlib has exactly this). But AFFINE — lives on `PrimeSpectrum R`, not the scheme's opens site.
- **Verdict**: ALIGN_WITH_MATHLIB — use these directly after reducing to an affine open. Do NOT rebuild.

### Decision 2: SES with projective/free quotient splits
- **Mathlib idiom**:
  - Categorical: `CategoryTheory.ShortComplex.ShortExact.splittingOfProjective : S.ShortExact → [Projective S.X₃] → [Balanced C] → S.Splitting` (`Mathlib.Algebra.Homology.ShortComplex.ShortExact`).
  - Also `ShortComplex.Splitting.ofExactOfSection`, `splittingOfInjective`.
  - Module-level: `Module.Projective.of_split`, `Module.Projective.of_free`, `Module.Projective.iff_split'`, `ModuleCat.projective_of_free`.
- **Gap**: identical.
- **Verdict**: ALIGN_WITH_MATHLIB. **Caution**: apply at the AFFINE/local-ring/`ModuleCat` level — a free
  SheafOfModules is NOT a projective OBJECT in `X.Modules`, so `splittingOfProjective` is wrong with `C = X.Modules`.
  The splitting is local: `H_x` free ⇒ projective over `O_{X,x}` (or over the affine ring) ⇒ stalk/affine SES splits
  ⇒ `K_x` a summand of free ⇒ projective f.p. ⇒ free. Use `Module.Projective.of_split` + `freeLocus_eq_univ_iff`.

### Decision 3: stalk functor on sheaves of modules
- **Mathlib status**: NO general `SheafOfModules.stalk` / `PresheafOfModules.stalk` (name search empty). Available:
  - `TopCat.Presheaf.stalk` on the underlying AddCommGrp sheaf (project already uses `X.presheaf.stalk`); and
    `SheafOfModules.toSheaf` / sheafification PRESERVE finite limits (kernels) — so kernels are computed underneath.
  - AFFINE only: `ModuleCat.tilde : ModuleCat R → (Spec R).Modules`, with
    `ModuleCat.Tilde.stalkIso : M.tildeInModuleCat.stalk x ≅ ModuleCat.of R (LocalizedModule p.primeCompl M)`
    (`Mathlib.AlgebraicGeometry.Modules.Tilde`). I.e. on an affine the stalk IS the localised module.
- **Gap**: NEEDS_MATHLIB_GAP_FILL — but the gap should be AVOIDED, not filled with a bespoke general stalk functor.
- **Verdict**: NEEDS_MATHLIB_GAP_FILL (route around it). DON'T build a general `SheafOfModules.stalk`. Reduce to
  affine opens `Spec R ⊆ X` (schemes are covered by affines), where Mathlib's affine stalk = `LocalizedModule`
  and the ENTIRE `freeLocus` openness machinery (Decision 1) applies. The genuine missing bridge is
  `(Spec R).Modules` (quasicoherent) ≃/→ `ModuleCat R` (via `ModuleCat.tilde` + `AffineScheme.Γ.rightOp.IsEquivalence`):
  Mathlib has `ModuleCat.tilde` one direction and the Spec–Γ ring equivalence, but NOT a packaged
  QCoh-`(Spec R).Modules` ≃ `ModuleCat R`. THIS bridge is the dominant remaining cost of the whole theorem.

## The headline theorem itself
`Mathlib.Algebra.Category.ModuleCat.Sheaf.LocallyFree` does NOT contain "kernel of an epi of locally free
is locally free" (no SES/kernel lemma; the module-level analogue is `ModuleCat.free_shortExact`, which is
the WRONG direction — X₁,X₃ free ⇒ X₂ free). So the theorem is genuine new content:
NEEDS_MATHLIB_GAP_FILL — but build it ON `SheafOfModules.IsLocallyFree`, not the bespoke predicate.

## Recommendation
Refactor `Scheme.Modules.IsLocallyFree` to (a specialisation/wrapper of) `SheafOfModules.IsLocallyFree`
at `R := X.ringCatSheaf`; delete `trivialBundle_isLocallyFree`/`isLocallyFree_of_iso` in favour of
`instIsLocallyFreeFree` + `IsLocallyFreeData` transport. Then prove Hartshorne III 6.5 by: locally-free ⇒
quasicoherent + finite presentation; cover `X` by affines `Spec R`; on each, `𝒢,ℋ` ↔ f.p. modules `G,H`
with `H` projective (locally free) ⇒ `0→K→G→H→0` SPLITS (`splittingOfProjective` / `Module.Projective.of_split`)
⇒ `K` projective f.p. ⇒ `freeLocus_eq_univ_iff` ⇒ `K` free at every prime ⇒ lift to `IsLocallyFreeData`.
The only infrastructure to build is the affine bridge `(Spec R).Modules_qc → ModuleCat R` (Decision 3),
plus the affine-cover lift for `IsLocallyFree` — NOT a stalk functor and NOT a parallel locally-free predicate.
