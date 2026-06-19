# Project Progress

## Current Stage
autoformalize

## Stages
- [x] init
- [x] dag
- [ ] autoformalize
- [ ] prover
- [ ] polish

## Notes
**P0a Foundations substrate COMPLETE** (iters 006–013, axiom-clean): two-tier sheaf-cohomology bridge,
heavy `IsGrothendieckAbelian X.Modules`, openwise + sheafified `Scheme.Modules.{exteriorPower,symPower}`.

**P0b eval-map / kernel-bundle substrate (iters 014–015):** `Scheme.Modules.{trivialBundle, evalMap,
evalKernel}`; `Basic.lean` `MR4213770.kernelBundle := evalKernel L` (FIRST genuine paper object);
Foundations Core 1 `trivialBundle_isLocallyFree` + step 4 `evalShortComplex_shortExact` + 3 helpers.
`Foundations.lean` ~1260 lines, 0 sorry, axiom-clean.

**THIS iter (016) — Core 2 decomposed + the kernel-bundle locally-free chain unblocked:**
The sole wall was `found:isLocallyFree_kernel_of_shortExact` (Hartshorne III Ex 6.5; no single Mathlib
anchor). A mathlib-analogist consult FABRICATED a `SheafOfModules.IsLocallyFree` Mathlib API — grep
DISPROVED it (absent in Mathlib v4.30.0), so the bespoke `Scheme.Modules.IsLocallyFree` is KEPT (the
must-fix ALIGN verdict is REJECTED). But the analogist's AFFINE/module-level anchors are VERIFIED-REAL
and Core 2 was effort-broken along an **affine-reduction route** over them into a 4-lemma chain:
- L1 `lem:isLocallyFree_local` — local freeness is local on the base (gluing trivialising covers).
- L2 `lem:module_kernel_free_basicOpen_cover` — `0→K→R^m→R^n→0` ⇒ K f.p. projective ⇒ free on a
  basic-open cover of `Spec R` (pure commutative algebra; fully Mathlib-anchored). **BOTTOM.**
- L3 `lem:kernel_iso_tilde_affine` — a free SES of `(Spec R).Modules` is `tilde` of an R-module SES,
  `𝒦 ≅ tilde K` (the affine quasicoherent⇄`ModuleCat R` bridge).
- L4 `lem:isLocallyFree_kernel_on_affine` — lift L2 through `tilde`; assemble on each affine. (Gated on
  L2+L3 → DEFERRED.)

HARD GATE GREEN — blueprint-reviewer `r16`: BOTH chapters complete+correct, 0 must-fix; all 8 new
`\mathlibok` anchors verified-real; leandag clean (0 unknown_uses/conflicts/isolated); blueprint-doctor
clean. Coverage debt cleared (3 helper nodes blueprinted: `found:restrict_free_iso`,
`found:locally_free_of_iso`, `found:eval_short_complex`); altitude gap on
`found:eval_shortexact_of_globally_generated` fixed (hypothesis now honestly `Epi (evalMap F)`).

Reminder (ARCHON_MEMORY): a mathlib-build lane on a zero-sorry file MUST lead its objective line with
the literal verb **"Scaffold"** or plan-validate drops it as `failed_all_noop`.

## Current Objectives

1. **`MR4213770UniversalSecantBundlesAndSyzygiesOfCanonicalCurves/Foundations.lean`** — **Scaffold** the
   three ready bottom sub-lemmas of the Core-2 affine-reduction chain INTO the file (currently ZERO open
   sorries — mathlib-build ADDs axiom-clean decls, NOT a fill-the-sorry task). Work bottom-up, axiom-clean,
   as far as it goes; NO `sorry` (each step fully proved or absent — clean STOP + handoff if walled).
   Blueprint: `chapters/Kemeny_PeerDependencies.tex`, the 4-lemma chain under
   `found:isLocallyFree_kernel_of_shortExact` (HARD GATE GREEN, blueprint-reviewer `r16`).
   [prover-mode: mathlib-build]

   Build these three (deps all done; mutually independent — do all three in one lane):
   1. **L2 — `Scheme.Modules.kernel_module_free_on_basicOpen_cover`** (`lem:module_kernel_free_basicOpen_cover`):
      a module SES `0 → K → R^m → R^n → 0` (R comm ring) with free quotient ⇒ K finitely-presented
      projective ⇒ K free on a basic-open cover `D(fᵢ)` of `Spec R`. Pure commutative algebra — the most
      anchored, attack FIRST. May be stated as a standalone `R`-module lemma and wrapped under
      `Scheme.Modules.*`. Anchors [verified this iter, Mathlib v4.30.0]:
      `CategoryTheory.ShortComplex.ShortExact.splittingOfProjective`, `Module.Projective.of_split`,
      `Module.Projective.of_free`, `Module.freeLocus`, `Module.isOpen_freeLocus`,
      `Module.freeLocus_eq_univ_iff`, `Module.basicOpen_subset_freeLocus_iff`,
      `Module.projective_of_localization_maximal`, `Module.free_of_flat_of_isLocalRing`.
      GUIDANCE (r16): you must supply the `Module.FinitePresentation R K` instance (f.g. projective ⇒
      f.p.) BEFORE the `freeLocus_*` lemmas fire — they all need `[Module.FinitePresentation R M]`.
   2. **L3 — `Scheme.Modules.kernel_iso_tilde_of_free_ses_affine`** (`lem:kernel_iso_tilde_affine`): a
      short exact sequence of `(Spec R).Modules` whose middle and right terms are free (`≅ free m`,
      `≅ free n`) is `tilde` of an `R`-module SES `0→K→R^m→R^n→0`, with the kernel `𝒦 ≅ tilde K`.
      Anchors [verified]: `AlgebraicGeometry.tilde`, `AlgebraicGeometry.tildeFinsupp`
      (`tilde (of R (ι →₀ R)) ≅ SheafOfModules.free ι`), `AlgebraicGeometry.tilde.fullyFaithfulFunctor`.
      GUIDANCE (r16): the module map `R^m→R^n` is epi because `tilde` is exact + fully faithful (hence
      conservative) and reflects the epi `𝒢→ℋ`; supply this reflection step.
   3. **L1 — `Scheme.Modules.isLocallyFree_of_isLocallyFree_cover`** (`lem:isLocallyFree_local`): local
      freeness is local on the base — if `X` has an open cover on each member of which `𝒦` is locally
      free of the same finite rank, then `𝒦` is locally free. `\uses{found:locally_free,
      found:locally_free_of_iso}` (both DONE). GUIDANCE (r16): needs the restrict-restrict iso
      `(𝒦|_{Uα})|_V ≅ 𝒦|_V` (restrictFunctor composition — Mathlib infra, no blueprint node).

   **DO-NOT-USE (FABRICATED — absent in this Mathlib, a prior advisor hallucinated them; grep-confirmed):**
   `SheafOfModules.IsLocallyFree`, `IsLocallyFreeData`, `instIsLocallyFreeFree`,
   `ModuleCat.Tilde.stalkIso`, `tildeInModuleCat`, `ModuleCat.tilde`/`ModuleCat.tildeFinsupp` (the real
   names are in the `AlgebraicGeometry` namespace). Keep the project's bespoke `Scheme.Modules.IsLocallyFree`.

   **OUT OF SCOPE (gated on L2+L3 — do NOT stub):** L4 `isLocallyFree_kernel_on_affine`, the target
   `isLocallyFree_kernel_of_shortExact`, `rank_kernel_of_shortExact`, `evalKernel_isLocallyFree`. Any NEW
   helper beyond the three named is coverage debt — list each with its `\uses` under "## Needs blueprint
   entry" in your task result.

   **HAZARDS (carried):** universe pins `.{u}` on bundle instances; `Module A N`/`IsScalarTower` do NOT
   auto-synth on base-changed targets (explicit binders).

## Out of scope this iter
- **The three deferred `Basic.lean` paper objects** — `lazarsfeldMukaiBundle` (E), `GrassmannPencilMap`,
  `BNPGen` (`def:kemeny_LM_bundle`, `lem:kemeny_grassmann_pencil_map`, `lem:kemeny_BNP_gen`). Appear
  "ready" on the leandag frontier but their `\uses` UNDER-DECLARES the real substrate (K3 Picard-rank-one
  lattice, curve inclusion `i:C↪X`, `g^1_{k+1}` pencils, pushforward `i_*A`, Brill–Noether `W^1_{k+1}`,
  the Grassmannian) — none built (P2/P3). A formalize prover there would emit fake statements (HARD GATE
  forbids). The three `opaque` stubs stay until their geometric substrate exists.
- **`def:kemeny_koszul_cohomology`** (`koszulCohomology`) — needs line-bundle tensor powers `L^q`,
  `H⁰(L^q)`, and the Koszul differentials; that substrate is a later mathlib-build lane.
- **Core-2 chain tip** — L4 + target + `rank_kernel_of_shortExact` + `evalKernel_isLocallyFree`: assemble
  next iter once L2/L3 land. `MR4213770.kernelBundle_isLocallyFree` (`lem:kemeny_kernel_bundle_locally_free`,
  Basic.lean) waits on the whole chain.
