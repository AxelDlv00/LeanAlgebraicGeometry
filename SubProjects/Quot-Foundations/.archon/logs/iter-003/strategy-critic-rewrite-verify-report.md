# Strategy Critic Report

## Slug
rewrite-verify

## Iteration
003

## Routes audited

### Route: FBC (direct-on-sections affine lemma + H⁰-equalizer globalization)

- **Goal-alignment**: PASS — produces the i=0 iso `g^* f_* F ⟶ f'_* g'^* F`, exactly the two target nodes (`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`).
- **Mathematical soundness**: PASS — the affine reduction through the proved tilde dictionaries to `cancelBaseChange`, then the H⁰-as-equalizer globalization where flat `−⊗B` preserves the finite kernel `∏Γ(Uᵢ) ⇉ ∏Γ(Uᵢⱼ)`, is the standard Stacks 02KH/02KG i=0 argument. It is genuinely Čech-cohomology-free (only the degree 0/1 sheaf condition). Mathlib support is unusually strong here (see prerequisite verification: `Module.Flat.ker_lTensor_eq` and the entire `Mathlib.RingTheory.Flat.Equalizer` file exist).
- **Effort honesty**: reasonable — FBC-A leans on already-proved `pushforward_spec_tilde_iso`/`gammaPushforwardTildeIso` (confirmed present and largely axiom-clean in `FlatBaseChange.lean`); FBC-B leans on the existing `Flat.Equalizer` infra. 150–400 / 150–350 LOC is credible.
- **Verdict**: SOUND

The one honestly-flagged residual risk (does `Γ(pushforwardBaseChangeMap)` identify with the canonical tensor iso without a mate computation) is correctly left as an empirical open question rather than asserted away. Good.

### Route: GF (thin-wrapper primary case + hand-built polynomial-ring dévissage residue)

- **Goal-alignment**: PASS — `genericFlatnessAlgebraic` + re-signed `genericFlatness` are the GF target node and its algebraic core.
- **Mathematical soundness**: PASS — verified directly against the source file. The primary case (`Module.Finite A M`) is a genuine thin wrapper over `Module.FinitePresentation.exists_free_localizedModule_powers` at the generic point and is already landed axiom-clean (`GenericFreeness.exists_free_localizationAway_of_finite`, lines 105–114). The `by_cases Module.Finite A M` split (line 188) is the natural base-case/induction split, not a gratuitous case split: the dévissage's bottom leaf IS the primary helper.
- **Infrastructure-deferral detected**: no — the residue (polynomial-ring generic freeness) is NOT deferred to upstream; it is explicitly the hand-built §4 dévissage with the gap precisely localized (prime filtration + Noether normalisation + poly-ring core).
- **Effort honesty**: mildly optimistic — GF-alg at 2–4 iters / 80–300 LOC for the full Nitsure §4 dévissage residue (prime-filtration reduction to `M = B/𝔭`, Noether normalisation `B_g` finite over `A_g[b₁..bₙ]`, induction on support dimension, poly-ring core) is on the lower edge of plausible. Not flagged as dishonest — the hard part is correctly isolated and the primary case really is discharged — but the planner should not be surprised if the residue runs to the top of the range or beyond.
- **Verdict**: SOUND

### Route: QUOT (cohomological-χ Hilbert polynomial + SNAP + GR-cells/glue/quot/repr)

- **Goal-alignment**: PASS — covers all four QUOT target nodes; the `Grassmannian := QuotFunctor (𝟙 S) V Φ_d` reduction and the P1/P2 predicate re-signs faithfully tighten the currently under-typed stubs (verified: `hilbertPolynomial`/`QuotFunctor`/`Grassmannian` in `QuotScheme.lean` are presently `_F : X.Modules` with no coherence/rank hypotheses, and `archon-protected.yaml` does NOT freeze them, so the re-sign is permitted).
- **Mathematical soundness**: PASS — the χ encoding, the SNAP S1/S2 decomposition, and the GR-cells/glue/quot/repr decomposition of the Grassmannian monolith are all faithful to Nitsure §1/§5. No unsound step.
- **Infrastructure-deferral detected**: no (not classic deferral — SNAP is planned in-project with S1/S2 sub-steps and an iter estimate, and the Grassmannian monolith is decomposed rather than parked) — BUT see effort honesty.
- **Effort honesty**: **under-counted (SNAP)** — SNAP S1 is "finiteness of coherent cohomology on a proper scheme over a field → χ : K₀ additive." The strategy itself confirms sheaf-cohomology χ for coherent sheaves is *absent* from `Mathlib/AlgebraicGeometry/`. Building higher coherent-sheaf cohomology + Serre/Grothendieck finiteness on proper schemes from nothing is not a 300–700 LOC / 4–8 iter task — it is a multi-month, project-dominating infrastructure effort in its own right. The estimate is the least honest cell in the table.
- **Verdict**: CHALLENGE

Two coupled issues the planner must address (in STRATEGY.md or via rebuttal):

1. **Čech-independence tension.** The project's identity is the "Čech-independent leg." The chosen Hilbert-polynomial encoding `Φ_s(m) = χ(X_s, F|_{X_s} ⊗ L_s^m) = Σᵢ(-1)ⁱ dim Hⁱ(...)` fundamentally requires *all* higher cohomology Hⁱ, i>0 — exactly the Čech/higher-cohomology machinery the leg was carved out to avoid. FBC stays at i=0 and GF is purely algebraic; QUOT's χ is the one place the leg's "Čech-independent" promise is silently broken. Either the framing is wrong or the encoding is.

2. **An unweighed lighter alternative exists** (see Alternative below): a graded Hilbert-function encoding routed *directly* through the already-verified `Polynomial.existsUnique_hilbertPoly`. The strategy currently places graded `hilbertPoly` *downstream* of χ ("a building block for the fiberwise polynomiality once χ is available") — the dependency arrow is plausibly backwards. If polynomiality (S2) can be obtained from the graded tool without first building coherent cohomology for all i, then S1 (the under-counted gap) may be largely avoidable.

The GR-* decomposition itself is sound and is the right "decompose like a Mathlib contributor" move; QUOT-repr's 6–12 iters / 400–1000+ LOC is open-ended but honestly so. The challenge is localized to the χ-vs-graded encoding decision and the SNAP estimate, not the Grassmannian routing.

## Format compliance

- **Size**: ~95 lines / well under budget — within budget (~250 lines / ~12 KB).
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order. `## Completed` correctly omitted (no phase fully closed yet).
- **Per-iter narrative detected**: no — prose is route-level, no "this iter"/"iter-NNN" references in STRATEGY.md (the `iter-236`/`iter-177+` tags live in the `.lean` file comments, not the strategy).
- **Accumulation detected**: no.
- **Table discipline**: PASS — six-column phases table, short inline Status tags (`ACTIVE`/`NEXT`/`BLOCKED`), LOC as remaining-LOC ranges.
- **Format verdict**: COMPLIANT

## Alternative routes (suggested)

### Alternative: Graded Hilbert-function encoding of `def:hilbert_polynomial`

- **What it looks like**: Define `Φ_s` via the graded Hilbert function of the section module `⊕_m Γ(X_s, F_s ⊗ L_s^m)` as a finitely-generated graded module over the homogeneous coordinate ring, and obtain polynomiality directly from Mathlib's verified `Polynomial.existsUnique_hilbertPoly` (`Mathlib.RingTheory.Polynomial.HilbertPoly`, confirmed present, the Hilbert–Serre / power-series `invOneSubPow` proof). This is the Hartshorne I.7.5 route and arguably closer to Nitsure §1's Snapper-via-Hilbert-function presentation. It yields the *same* polynomial (no type weakening — for m≫0 it equals χ).
- **Why it might be cheaper or sounder**: it keeps QUOT inside the Čech-independent leg, leans on an already-landed Mathlib building block rather than constructing coherent cohomology for all i, and collapses S1 (the severely under-counted gap) to "relate `F` to a finitely-generated graded module" — which, while still real work (Serre's `⊕Γ(F⊗L^m)` correspondence), is far lighter than full higher-coherent-cohomology finiteness.
- **What the current strategy may have rejected**: the honest counter is that H⁰ is only left-exact, so *Snapper's classical polynomiality proof* uses χ's additivity on short exact sequences. But `existsUnique_hilbertPoly` proves polynomiality of the *graded* Hilbert function purely algebraically (graded module over a polynomial ring), sidestepping the need for χ-additivity at the sheaf level. The strategy does not engage this; it asserts graded `hilbertPoly` is downstream of χ without justifying why χ must come first.
- **Severity of the omission**: major

## Prerequisite verification

- `Polynomial.hilbertPoly`: VERIFIED (`Mathlib.RingTheory.Polynomial.HilbertPoly`)
- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (same module; note `[CharZero F]` hypothesis)
- `cancelBaseChange`: VERIFIED as `TensorProduct.AlgebraTensorModule.cancelBaseChange` / `Algebra.TensorProduct.cancelBaseChange` (bare name in strategy is shorthand)
- `Module.Flat.ker_lTensor_eq`: VERIFIED (`Mathlib.RingTheory.Flat.Equalizer` — a whole file of flat-preserves-equalizer infra, incl. `tensorKerEquiv`, `kerLTensorEquivOfSurjective`; strongly backs FBC-B)
- `exists_free_localizedModule_powers`: VERIFIED as `Module.FinitePresentation.exists_free_localizedModule_powers` (used and compiling in `FlatteningStratification.lean`)
- `Functor.RepresentableBy`: VERIFIED (used in `QuotScheme.lean`); note the strategy's "representability stated as `IsRepresentable`" is loose wording — the actual stub uses `RepresentableBy Y` wrapped in `∃ Y, Nonempty (… .RepresentableBy Y)`. Harmless, but align the prose.
- RelativeSpec status: CONFIRMED — `UniversalProperty` is proved only as `IsAffineHom` and `affine_base_iff` only as `IsAffine` (not the `RepresentableBy`/canonical-iso forms), exactly as the open question states.

## Must-fix-this-iter

- Route QUOT: CHALLENGE — resolve the χ-vs-graded encoding decision. Either (a) justify in STRATEGY.md why the cohomological-χ encoding (which needs all Hⁱ and breaks the "Čech-independent leg" framing) is required over the graded `existsUnique_hilbertPoly` route, and re-estimate SNAP S1 honestly as a major coherent-cohomology infrastructure phase; or (b) pivot `def:hilbert_polynomial` to the graded Hilbert-function encoding and re-scope SNAP accordingly.
- Alternative (graded Hilbert-function encoding): major omission — must be explicitly weighed and either adopted or rebutted on its merits.
- SNAP effort: under-counted — 300–700 LOC / 4–8 iters for from-scratch coherent-sheaf cohomology + proper-over-field finiteness is not credible; correct the estimate or shrink the scope via the alternative.

## Overall verdict

FBC and GF are SOUND: both are goal-aligned, mathematically standard, and — verified directly against the source files and Mathlib — unusually well-supported by existing infrastructure (`Flat.Equalizer`, `cancelBaseChange`, the landed `GenericFreeness` wrapper); GF's dévissage-residue estimate is merely optimistic, not dishonest. The QUOT rewrite is mathematically faithful to Nitsure §1/§5 and its GR-cells/glue/quot/repr decomposition is the right move, but it carries one real CHALLENGE: the cohomological-χ Hilbert-polynomial encoding requires building higher coherent-sheaf cohomology and proper-over-field finiteness for all i — which sits in direct tension with the project's "Čech-independent leg" identity and is severely under-counted in the SNAP row — while a lighter, Čech-independent alternative routed through the already-verified `Polynomial.existsUnique_hilbertPoly` is never weighed. The planner must either justify the χ encoding (and re-estimate SNAP honestly) or pivot to the graded Hilbert-function encoding. Format is COMPLIANT. No phantom prerequisites, no hallucinated routes, no sequencing errors.
