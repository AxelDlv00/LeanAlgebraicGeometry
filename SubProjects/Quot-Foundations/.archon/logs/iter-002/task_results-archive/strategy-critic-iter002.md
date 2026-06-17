# Strategy Critic Report

## Slug
iter002

## Iteration
002

## Routes audited

The strategy frames the leg as "single route per target" — three independent sub-legs (FBC, GF,
QUOT). I audit by sub-leg. Note: `## Routes` only contains explicit route prose for **FBC**; the GF
and QUOT routes are documented only implicitly via the phase table + Mathlib-gaps section. That
thinness is itself a finding (see each block + Format).

### Route: FBC (affine lemma + H⁰-equalizer globalization)

- **Goal-alignment**: PASS — produces exactly the i=0 iso `g*f_*F ≅ f'_*g'^*F` for quasi-coherent F.
- **Mathematical soundness**: PASS — this is Stacks 02KH(2). For i=0 the iso holds for *quasi-coherent*
  F with no coherence/finiteness hypothesis (correctly: contrast GF, which genuinely needs finiteness);
  the H⁰-as-equalizer + flat-`−⊗B`-preserves-finite-equalizer argument is genuinely Čech-cohomology-free.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — the iter-001 pivot is a *real* pivot. Old route's hardest
  prereq was the deferred upstream PR `#37189` / abstract categorical mate; new route's hardest prereq is
  the SheafOfModules H⁰-equalizer packaging + a concrete section-level identification, both buildable with
  existing lemmas. The hard problem genuinely changed.
- **Phantom prerequisites**: none. `Module.Flat.ker_lTensor_eq` and `Module.Flat.eqLocus_lTensor_eq`
  VERIFIED in `Mathlib/RingTheory/Flat/Equalizer.lean`; module-level
  `TensorProduct.AlgebraTensorModule.cancelBaseChange` (the reduction target `(R'⊗_R A)⊗_A M ≅ R'⊗_R M`)
  VERIFIED.
- **Effort honesty**: reasonable — FBC-B's 150–350 LOC for building H⁰-equalizer/sheaf-condition infra
  for `SheafOfModules` from scratch + the qsep Mayer–Vietoris induction is slightly optimistic at the low
  end but the range is honest.
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND — with one honestly-disclosed residual risk (Open question 3): if identifying
  `Γ(pushforwardBaseChangeMap)` with the canonical tensor iso *does* need a mate computation, the pivot
  partially re-meets the coherence wall one layer deeper. The strategy flags this for empirical
  validation and the residue is concrete/buildable (not a deferred PR), so it is a watch-item, not a
  blocking finding. Minor clarity nit: the bare word "cancelBaseChange" denotes two different objects in
  the doc — the *dropped* categorical mate decomposition and the *retained* module-level iso (FBC-A row).
  Disambiguate.

### Route: GF (algebraic generic-freeness core + geometric genericFlatness)

- **Goal-alignment**: PASS — and the strategy correctly identifies that the inherited `genericFlatness`
  signature is false without a finiteness hypothesis and must be re-signed `[IsQuasicoherent]+[IsFiniteType]`.
- **Mathematical soundness**: PASS — standard Nitsure §4 generic flatness. The strategy correctly notes
  `exists_free_localizedModule_powers` alone does not close it (M is finite over B, finite-type over A,
  and is generally *not* finitely presented as an A-module — exactly why the polynomial-ring dévissage
  residue survives). The residue is real, not phantom.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none. `Module.FinitePresentation.exists_free_localizedModule_powers`
  VERIFIED in `Mathlib/RingTheory/Localization/Free.lean`; `Module.freeLocus` VERIFIED in
  `Mathlib/RingTheory/Spectrum/Prime/FreeLocus.lean`.
- **Effort honesty**: reasonable — GF-alg's 80 LOC low end is optimistic for a hand-built dévissage, but
  the 80–300 range covers the realistic case.
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND.

### Route: QUOT (Hilbert poly, Quot functor, Grassmannian, Grassmannian representability)

- **Goal-alignment**: PARTIAL — two of the four nodes carry undecided foundational dependencies (Snapper
  χ; Grassmannian-as-scheme) that the strategy lists as gaps but neither decides nor decomposes.
- **Mathematical soundness**: PASS (the math is standard Nitsure §1/§2/§5); the issue is *route
  engineering*, not correctness.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — two items (see Infrastructure-deferral findings):
  (1) "Snapper χ polynomiality" is listed as an absent gap to hand-build, required by the goal node
  `def:hilbert_polynomial`, with no sub-phase and no timeline — *and the strategy overlooks that Mathlib
  already ships graded Hilbert–Serre machinery that may discharge the node without Snapper at all*.
  (2) "Grassmannian-of-quotients as a scheme" is a 400–1000+ LOC BLOCKED monolith with a timeline but
  zero decomposition into concrete sub-phases.
- **Phantom prerequisites**: none among named items — `Functor.IsRepresentable`
  (= `CategoryTheory.Functor.IsRepresentable`), `RepresentableBy`, `AlgebraicGeometry.IsProper`, and
  `Scheme.Modules` all VERIFIED. `IsLocallyFree` is correctly described as not-at-pin (the rank-`r`
  predicate is a planned project-side build).
- **Effort honesty**: under-counted at the low ends. QUOT-defs (250–700 LOC) bundles a full Snapper χ
  build *if* the cohomological encoding is chosen — Snapper alone is a multi-hundred-LOC theorem, so 250
  is not credible under that encoding. QUOT-repr's 400 LOC low end for constructing + gluing a scheme and
  proving representability is very optimistic; the `1000+` acknowledges the open-endedness honestly.
- **Parallelism under-exploited**: no at the leg level (FBC/GF/QUOT explicitly parallel; QUOT's four
  files import only Mathlib), though QUOT-defs bundles four parallel-authorable files into one phase row.
- **Verdict**: CHALLENGE — resolve the two foundational dependencies (decide the `hilbert_polynomial`
  encoding against the existing Mathlib `hilbertPoly`; decompose the Grassmannian-as-scheme phase) before
  sinking iters into building absent infrastructure.

## Format compliance

- **Size**: STRATEGY.md proper (`## Goal` … `## Mathlib gaps & new material`) ≈ 74 lines / well under
  budget — within budget (~250 lines / ~12 KB).
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`,
  `## Mathlib gaps & new material`, in order; `## Completed` correctly omitted (nothing done yet).
  (The `## References index` / `## Blueprint summary` blocks in the directive are directive sections, not
  part of STRATEGY.md.)
- **Per-iter narrative detected**: yes — `**FBC route (pivoted iter-001).**` and
  `QUOT (surfaced iter-001):` embed specific-iteration references in prose. Per-iter history belongs in
  `iter/iter-NNN/plan.md`. Strip the parentheticals (the route stands on its merits without the iter tag).
- **Accumulation detected**: no.
- **Table discipline**: PASS — `## Phases & estimations` is a well-formed six-column table, one short
  line per cell, inline status tags, LOC as ranges.
- **Format verdict**: DRIFTED — minor: per-iter narrative phrases to strip, and `## Routes` documents
  only the FBC route while GF and QUOT carry no route prose. Add one short route paragraph each for GF
  and QUOT so the section matches its "single route per target" claim.

## Infrastructure-deferral findings

### Deferred: Snapper χ polynomiality (for `def:hilbert_polynomial`)

- **Required by goal**: partially — `def:hilbert_polynomial` is one of the seven goal nodes. Whether it
  requires Snapper depends on the node's *type*: a cohomological `P(n) = χ(F(n)) : Polynomial ℚ` requires
  Snapper (sheaf-cohomology Euler characteristics — absent; `eulerCharacteristic` for coherent sheaves
  not in Mathlib). A graded Hilbert–Serre definition does NOT: Mathlib already ships
  `Polynomial.hilbertPoly` and `Polynomial.existsUnique_hilbertPoly` (`Mathlib/RingTheory/Polynomial/HilbertPoly.lean`),
  which give the polynomial of a finite-length graded module over a polynomial ring. On a projective
  scheme over a field (fiberwise, via the fixed relative very-ample L) this discharges the node without
  cohomological χ.
- **Current plan for building it**: vague — listed under "Mathlib gaps … Snapper χ polynomiality" and
  bundled into the QUOT-defs risk cell ("Snapper polynomiality deep"); no dedicated phase row, no timeline,
  and the existing Mathlib `hilbertPoly` off-ramp is not mentioned.
- **Timeline**: absent (buried in QUOT-defs' 5–9 iters / 250–700 LOC, which cannot absorb a full Snapper
  build under the cohomological encoding).
- **Verdict**: CHALLENGE — decide the `hilbert_polynomial` encoding first. If the Mathlib graded
  `hilbertPoly` route fits the parent's node type, the "Snapper χ polynomiality" gap largely dissolves;
  if the cohomological encoding is mandatory, Snapper needs its own decomposed sub-phase with an honest
  LOC/iter estimate, not a one-line risk note.

## Alternative routes (suggested)

### Alternative: Hilbert polynomial via Mathlib's graded `Polynomial.hilbertPoly`

- **What it looks like**: Define `def:hilbert_polynomial` for a coherent sheaf on a projective scheme
  over a field through its associated finitely-generated graded module Γ_*(F) and Mathlib's
  `Polynomial.hilbertPoly` / `existsUnique_hilbertPoly`, rather than via the cohomological Euler
  characteristic χ(F(n)) and a hand-built Snapper polynomiality theorem.
- **Why it might be cheaper or sounder**: it reuses already-merged Mathlib infrastructure for the single
  hardest "gap" the strategy names, potentially turning a multi-hundred-LOC deep theorem into a wrapper.
- **What the current strategy may have rejected**: unclear — the strategy does not mention
  `Polynomial.hilbertPoly` at all, so this looks like an un-surveyed option rather than a rejected one.
  Caveat: the cohomological χ is the invariant that is locally constant in flat families and indexes the
  full Quot functor; if the parent's downstream `def:quot_functor` needs the *flat-family* χ rather than a
  single-sheaf graded Hilbert polynomial, the graded route may not extend. Validate against the parent's
  node types before committing.
- **Severity of the omission**: major.

## Must-fix-this-iter

- Route QUOT: CHALLENGE — decide the `def:hilbert_polynomial` encoding (cohomological χ + Snapper vs
  Mathlib graded `Polynomial.hilbertPoly`); the strategy currently lists Snapper as an absent gap without
  surveying the existing Mathlib machinery and without a sub-phase/timeline.
- Route QUOT: infrastructure-deferral CHALLENGE — "Grassmannian-of-quotients as a scheme" (required by
  `thm:grassmannian_representable`) is a 400–1000+ LOC BLOCKED monolith with no decomposition. Break it
  into concrete sub-phases (affine big cells; gluing/patching; quotient-bundle universal property;
  functor-of-points identification) with per-sub-phase estimates, rather than carrying one undecomposed
  1000-LOC row.
- Alternative "graded `hilbertPoly`": major omission — survey it before building Snapper.
- Format: DRIFTED — strip per-iter parentheticals (`(pivoted iter-001)`, `(surfaced iter-001)`) and add a
  one-paragraph route description each for GF and QUOT so `## Routes` covers all three targets, not only FBC.

## Overall verdict

FBC and GF are SOUND: the math is standard, the iter-001 FBC pivot is a genuine pivot (the hardest
prerequisite changed from a deferred upstream PR to a concretely-buildable equalizer argument), and every
named Mathlib prerequisite I checked — `Module.Flat.{ker,eqLocus}_lTensor_eq`,
`exists_free_localizedModule_powers`, `Module.freeLocus`, `cancelBaseChange`, `Functor.IsRepresentable`,
`RepresentableBy`, `IsProper`, `Scheme.Modules` — VERIFIED. The QUOT leg earns a CHALLENGE: the strategy
defers Snapper χ polynomiality, which is required for the goal node `def:hilbert_polynomial` under its
cohomological encoding, with no sub-phase and no timeline — while overlooking that Mathlib's existing
graded `Polynomial.hilbertPoly` may discharge that node without Snapper at all; and the
Grassmannian-of-quotients scheme construction, required for `thm:grassmannian_representable`, sits as a
single undecomposed 400–1000+ LOC BLOCKED phase. Neither is fatal (both have project-side intent and the
QUOT files are parallelizable), but the planner must, this iter, (a) decide the Hilbert-polynomial
encoding against the existing Mathlib machinery, (b) decompose the Grassmannian-as-scheme phase into
concrete sub-phases with estimates, and (c) fix the minor format drift (per-iter parentheticals; missing
GF/QUOT route prose) — or record an explicit rebuttal in `iter/iter-002/plan.md`.
