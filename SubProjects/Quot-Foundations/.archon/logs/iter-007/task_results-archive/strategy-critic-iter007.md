# Strategy Critic Report

## Slug
iter007

## Iteration
007

## Routes audited

### Route: FBC (affine direct-on-sections + Čech-free globalization)

- **Goal-alignment**: PASS — the i=0 base-change iso `g^*f_*F ⟶ f'_*g'^*F` is exactly what the affine lemma + globalization produce; matches the two named nodes.
- **Mathematical soundness**: PASS — for `i=0` the canonical skeleton *is* "H⁰ = sheaf-condition equalizer `∏Γ(Uᵢ) ⇉ ∏Γ(Uᵢⱼ)` + flat `−⊗B` preserves that finite equalizer". This is the standard reduction (Stacks 02KH part (2)) and deliberately avoids the Čech-to-derived spectral sequence that the `i>0` case needs. No simpler path exists: an affine target forces the reduction to modules and `cancelBaseChange`, which is what the route does.
- **Sunk-cost reasoning detected**: no — the route in fact *drops* prior scaffolding (the parent's adjoint-mate ↔ `cancelBaseChange` decomposition and the deferred Mathlib `#37189` dependency) in favor of the directer path. That is anti-sunk-cost.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none — `Algebra.TensorProduct.cancelBaseChange` VERIFIED; `Module.Flat.ker_lTensor_eq` + `LinearMap.tensorEqLocusEquiv` VERIFIED (an entire dedicated `Mathlib.RingTheory.Flat.Equalizer` file exists — see Prerequisite verification; this de-risks FBC-B's "H⁰-as-equalizer / flat preserves equalizer" piece more than the strategy claims).
- **Effort honesty**: reasonable — FBC-A ~150–400 / FBC-B ~150–350 is consistent with "identify Γ(map) with the tensor iso + qsep Mayer–Vietoris equalizer plumbing".
- **Verdict**: SOUND

### Route: GF (Nitsure §4 prime-filtration + Noether-normalization dévissage)

- **Goal-alignment**: PASS — algebraic core `genericFlatnessAlgebraic` + geometric wrapper `genericFlatness` hits `thm:generic_flatness` (+ its algebraic core node).
- **Mathematical soundness**: PASS — this is the textbook generic-flatness proof (EGA IV 6.9.1 / Stacks 051R / Nitsure §4): dévissage by a prime filtration `B/pᵢ`, Noether-normalize to reduce to the module-finite primary case at the bottom. Decomposition is canonical.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — the genuinely Mathlib-absent piece (finite-type dévissage residue) is named as the hand-built `lem:gf_polynomial_core` and not deferred upstream.
- **Phantom prerequisites**: `exists_free_localizedModule_powers` exists as `Module.FinitePresentation.exists_free_localizedModule_powers` (strategy abbreviated the namespace — fine). I could not surface `induction_on_isQuotientEquivQuotientPrime` via search; flagging it for the planner to re-confirm the exact current name before building on it (the prime-filtration induction does exist in Mathlib's `RingTheory` under some name — `Module.induction_on_prime`-family — but the literal string did not resolve).
- **Effort honesty**: reasonable — GF-alg ~120–400 / GF-geo ~40–120. I confirmed Mathlib has **no** full generic-flatness lemma (only the `Module.freeLocus` machinery + the primary-case localization lemma), so the residue is genuine work, not a thin wrapper being over-billed.
- **Verdict**: SOUND

### Route: QUOT (graded Hilbert-function encoding + predicate sub-builds + GR-* decomposition)

- **Goal-alignment**: PASS — and notably the graded/H⁰ encoding is *more* aligned with the construction than the cohomological χ would be: Nitsure §5 builds Quot/Grassmannian by embedding into `Grass(H⁰(F(m)), P(m))`, i.e. via section modules, so the H⁰-graded route is the construction's native language.
- **Mathematical soundness**: PASS — the polynomial `Φ_s` extracted from `m ↦ dim_κ Γ(X_s, F_s⊗L_s^m)` agrees with the cohomological χ for `m≫0` (Serre vanishing), so it is the *same* polynomial despite differing function values at small `m`; defining it via the graded Hilbert function (Hartshorne I.7.5) avoids all `Hⁱ (i>0)`. Crucially, this project's closure targets `thm:grassmannian_representable` (Grassmannian = `QuotFunctor (𝟙 S) V Φ_d`, Quot of a locally-free `V` over the base itself), **not** the full Quot-of-a-coherent-sheaf-on-ℙⁿ — so the one place where "Čech-independent" could be strained (uniform Castelnuovo–Mumford `m`-regularity / local-constancy of χ in flat families, which leans on higher-cohomology vanishing) is **outside** this leg's closure. The graded encoding's load here is correspondingly light. Sound.
- **Sunk-cost reasoning detected**: no — the encoding pivot was a re-derivation on the merits (avoid building coherent cohomology from scratch), and the rejected cohomological-χ alternative is named with its reason.
- **Infrastructure-deferral detected**: no (but see RelativeSpec note below — it is acceptable sequencing, not avoidance). The Mathlib-absent `gradedModule_hilbertSeries_rational` is a *named project build* with a concrete classical-induction plan and a 2–4 iter SNAP estimate, not an upstream punt.
- **Phantom prerequisites**: `Polynomial.existsUnique_hilbertPoly` VERIFIED (extraction half, as claimed); `CategoryTheory.Functor.IsRepresentable` + `RepresentableBy` VERIFIED (so the representability target and the RelativeSpec-strengthening Yoneda form rest on real Mathlib notions). `Scheme.Modules.pullback` / `IsProper` not spot-checked but are standard AG-namespace fixtures.
- **Effort honesty**: reasonable, with QUOT-repr (~400–1000+, 6–12 iters) honestly flagged as "deepest target" and pre-decomposed into GR-cells/GR-glue/GR-quot/GR-repr with per-sub-phase LOC. The open top end ("1000+") is the right way to carry the uncertainty; not a dishonest under-count.
- **Parallelism under-exploited**: no — opening QUOT-defs as a third ACTIVE lane alongside FBC-A and GF-alg is correct: the three legs are genuinely independent (the goal itself calls them "a fan of independent leaves"), and all four QUOT files import only Mathlib. Serializing them would have implicitly tripled the iter count.
- **Verdict**: SOUND

## Format compliance

- **Size**: ~121 lines / well under budget — within budget (~250 lines / ~12 KB).
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order. `## Completed` correctly omitted (no full phase done yet).
- **Per-iter narrative detected**: yes — iter-numbered narrative appears in prose/cells, e.g. `*Hilbert-polynomial encoding = graded Hilbert function* (PIVOT iter-003, addressing the strategy-critic CHALLENGE)`, `The QUOT chapter ... was rewritten to the graded encoding (iter-003)`, and the GF-alg risk cell `decomposed iter-003 into a 5-lemma chain`. The skeleton permits bare iter numbers only in a `## Completed` table's `Iters` cell; these are prose/risk-cell references and belong in an iter sidecar.
- **Accumulation detected**: no (mild) — already-landed sub-results ("primary case already landed axiom-clean", "proved tilde dictionaries") are narrated inline rather than in a `## Completed` table, but they are sub-lemmas, not finished phases, so no completed *phase* is stranded in the active table.
- **Table discipline**: PASS — columns are Phase | Status | Iters left | LOC | Key Mathlib needs | Risks; Status is inline tag; LOC is a remaining-LOC range.
- **Format verdict**: DRIFTED

## Open strategic questions (critic notes, not blockers)

- **Merge-back vs. re-sign.** The goal requires names/labels to match the parent so work "merges back into its A.2.c engine," yet GF-geo and the QUOT stubs are *re-signed* with added `[IsQuasicoherent]`+`[IsFiniteType]`. Confirm the parent's cone expects exactly these strengthened signatures (and that none of the seven nodes is a frozen protected signature that the re-sign would violate). If the parent's `thm:generic_flatness` carries a different signature, the re-signed form will not merge back cleanly — a goal-alignment risk worth an explicit one-line confirmation, not a route defect.
- **RelativeSpec strengthening** is correctly deferred (QUOT-repr is BLOCKED and 6–12 iters out) and offers two concrete escape routes (strengthen RelativeSpec to a `RepresentableBy` witness vs. a transpose-free gluing argument). `RepresentableBy` is a real Mathlib notion (verified), so neither route rests on phantom infra. Acceptable as a deferred *decision*, since the underlying Grassmannian-as-scheme construction itself is planned (GR-cells/GR-glue with LOC + a blueprint chapter), not deferred.

## Prerequisite verification

- `Polynomial.existsUnique_hilbertPoly`: VERIFIED (`Mathlib/RingTheory/Polynomial/HilbertPoly.lean`).
- `Algebra.TensorProduct.cancelBaseChange`: VERIFIED (also `TensorProduct.AlgebraTensorModule.cancelBaseChange`).
- `Module.Flat.ker_lTensor_eq`, `LinearMap.tensorEqLocusEquiv`: VERIFIED (dedicated `Mathlib.RingTheory.Flat.Equalizer` — richer than the strategy's `Module.Flat.{ker,eqLocus}_lTensor_eq` shorthand implies; this is good news for FBC-B).
- `exists_free_localizedModule_powers`: VERIFIED as `Module.FinitePresentation.exists_free_localizedModule_powers` (strategy dropped the namespace prefix).
- `CategoryTheory.Functor.IsRepresentable`, `CategoryTheory.Functor.RepresentableBy`: VERIFIED.
- Full generic-flatness lemma in Mathlib: MISSING (only `Module.freeLocus` machinery + primary-case localization) — confirms GF's hand-built residue is genuine, not redundant.
- `induction_on_isQuotientEquivQuotientPrime`: could not resolve the literal name via search — planner should re-confirm the exact current Mathlib name for the prime-filtration induction before building `lem:gf_polynomial_core` on it.

## Must-fix-this-iter

- Format: DRIFTED — strip the three `iter-003` per-iter-narrative references from `STRATEGY.md` prose/risk cells (move any needed history to an iter sidecar). Minor but should be cleaned in-place this iter.
- Prerequisite re-confirm: verify the exact Mathlib name backing `induction_on_isQuotientEquivQuotientPrime` before GF-alg builds on it.

## Overall verdict

All three strategic routes are SOUND. FBC's direct-on-sections, Čech-free path is the canonical `i=0` skeleton (not a workaround), and Mathlib's `Flat.Equalizer` file makes FBC-B less risky than stated. GF's Nitsure §4 prime-filtration + Noether-normalization dévissage is the textbook decomposition; I confirmed Mathlib has no full generic-flatness lemma, so the residue is real and correctly scoped. The QUOT graded-Hilbert-function encoding is sound, agrees with the cohomological χ for `m≫0`, and is actually the construction's native language (Nitsure §5); because this leg's closure targets the Grassmannian and the Hilbert-polynomial *definition* — not the full Quot-on-ℙⁿ — the regularity/local-constancy machinery that would re-introduce higher cohomology stays outside the closure, so "Čech-independent" genuinely holds. Opening QUOT-defs as a third parallel lane is correct, not over-extension, given the three legs are independent. No CHALLENGE or REJECT. The only must-fix items are housekeeping: a DRIFTED format (per-iter `iter-003` narrative in prose) to clean in-place, one Mathlib name to re-confirm, and a one-line confirmation that the re-signed `[IsQuasicoherent]`+`[IsFiniteType]` signatures match what the parent cone expects so the merge-back requirement in the goal still holds. No construction required by the goal is being deferred without a concrete project-side plan.
