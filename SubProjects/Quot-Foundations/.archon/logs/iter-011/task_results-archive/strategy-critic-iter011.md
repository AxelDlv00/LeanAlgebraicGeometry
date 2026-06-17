# Strategy Critic Report

## Slug
iter011

## Iteration
011

## Routes audited

The strategy declares three routes (FBC, GF, QUOT), each fanning into the
phases of `## Phases & estimations`. I audit per route, breaking out the
sub-phase where a verdict differs.

### Route: FBC (FBC-A affine lemma + FBC-B globalization)

- **Goal-alignment**: PASS — both `lem:affine_base_change_pushforward` and
  `thm:flat_base_change_pushforward` (the i=0 iso) are the leaf targets, and the
  direct-on-sections + flat-equalizer plan terminates exactly at that iso.
- **Mathematical soundness**: PASS — the value-on-sections is pinned by the single
  identity `Γ(θ) = lTensor R' η_M` post-composed with the regroup iso built from
  `Algebra.IsPushout.cancelBaseChange`; globalization is the degree-0/1 sheaf-condition
  equalizer with flat `−⊗B` commuting with the finite kernel. No cohomology enters.
- **Sunk-cost reasoning detected**: no — the iter-009 drop of the parent's
  adjoint-mate tower is itself an anti-sunk-cost simplification (abandoned the
  inherited abstract decomposition for a shorter direct route).
- **Phantom prerequisites**: none. `Algebra.IsPushout.cancelBaseChange` (+
  `_tmul`/`_symm_tmul` simp lemmas), `Module.Flat.ker_lTensor_eq`, and
  `LinearMap.tensorEqLocusEquiv` (+ `_apply`, `lTensor_eqLocus_subtype_tensoreqLocusEquiv_symm`)
  all verified present in `Mathlib.RingTheory.IsTensorProduct` /
  `Mathlib.RingTheory.Flat.Equalizer` — exactly the module FBC-B names.
- **Effort honesty**: reasonable — FBC-A 2–3 iters / ~120–300 LOC and FBC-B 2–5 /
  ~120–300 are consistent with "one section identity + restriction-compat" and
  "equalizer packaging over a Mathlib-backed flat half."
- **Verdict**: SOUND

**Q1 (internal consistency after the iter-009 rewrite): CONFIRMED CONSISTENT.**
The three places that previously contradicted now agree: the `## Routes` prose
("the 3 mate sub-lemmas ... are superseded by the single section identity"), the
FBC-A phase row Risks cell ("mate tower dropped; residual = the one section
identity"), and the `## Mathlib gaps` FBC-A entry (lists only the section identity
+ the object-level diamond bridge). No residual mate-tower obligation survives in
phases or gaps. The route matches the `Cohomology_FlatBaseChange.tex` /
`Cohomology_RegroupHelper.tex` chapter split (regroup iso isolated into its own
chapter via `cancelBaseChange`).

**Q2 (genuinely Čech-cohomology-free): CONFIRMED.** `H⁰(X,F)` as the equalizer
`∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)` is the sheaf axiom (a finite limit, Čech degrees 0/1
only), not a derived functor; a flat module commutes with that finite kernel by
`ker_lTensor_eq`/`tensorEqLocusEquiv`. The named pieces are the right ones and
live in the named module. Only standing obligation (correctly flagged as the
residual): the finite-affine-cover sheaf-condition packaging for
`SheafOfModules`, which presumes a quasi-compact/quasi-separated (finite cover,
finite intersections) hypothesis — fine in the Noetherian setting this leg lives in.

### Route: GF (GF-alg algebraic core + GF-geo geometric wrapper)

- **Goal-alignment**: PASS — `genericFlatnessAlgebraic` is the stated core and
  `genericFlatness` (re-signed `[IsQuasicoherent]`+`[IsFiniteType]`) the geometric
  target; both are leaf nodes of the goal.
- **Mathematical soundness**: PASS — see Q3. The generic-rank SES over `P_d`
  directly (no `g`-inversion) and the Nagata single-variable reindex to
  `MvPolynomial (Fin (d-1)) A_g` are the standard Nitsure §4 dévissage.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
  `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` verified present
  (`Mathlib.RingTheory.Ideal.AssociatedPrime.Finiteness`). No packaged
  `genericFlatness`/generic-freeness theorem exists upstream (search surfaced only
  `Module.freeLocus`, `Module.free_of_isLocalizedModule`, flat-localization
  stability) — so GF-alg is genuinely new material, not redundant with Mathlib.
- **Effort honesty**: reasonable — GF-alg 2–3 / ~120–350 across four named atoms +
  shared engine; GF-geo 1–2 / ~40–120 for the affine-cover wrapper. The single-variable
  Nagata elimination engine is the real risk inside that range, but the LOC band is wide
  enough to absorb it.
- **Parallelism under-exploited**: no — GF-alg runs concurrently with FBC-A and QUOT.
- **Verdict**: SOUND

**Q3 (induction motive correctness): CONFIRMED SOUND, no hidden circularity.**
Generalizing the base domain `A` into the `Nat.strong_induction_on d` motive
(reverting `A` + instances) is the correct maneuver precisely because the Nagata
reindex changes the base ring to `A_g`, so the IH must hold for an *arbitrary*
Noetherian domain base, not the fixed `A`. There is no circularity: the IH is
invoked only at strictly smaller variable count `d-1`; the base ring varying does
not affect well-foundedness on `d`. The two implicit obligations the prose leaves
tacit but does not need to state — `A_g` is again a Noetherian domain (localization
of a Noetherian domain) and the `(A N : Type u)` shared-universe pin so the motive
typechecks across the step — are both standard and the strategy correctly anticipates
the universe constraint. The effort-break (`gf_generic_rank_ses` +
`gf_torsion_reindex`, the latter into annihilator-extraction / Nagata change-of-vars /
Mathlib anchor / shared `gf_mvPolynomial_quotient_finite_monic`, with L4 sharing the
same engine) is a concrete mathlib-contributor-style atomization, not deferral.

### Route: QUOT (QUOT-defs + SNAP Hilbert polynomial + QUOT-repr)

- **Goal-alignment**: PASS — covers `def:hilbert_polynomial`, `def:quot_functor`,
  `def:grassmannian_scheme`, `thm:grassmannian_representable`.
- **Mathematical soundness**: PARTIAL — the SNAP encoding has one load-bearing
  cohomology-freeness claim (S1) that the prose asserts rather than establishes; see
  Q4 and the CHALLENGE below. QUOT-defs and QUOT-repr are sound.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none that are claimed-present-but-absent.
  `Polynomial.existsUnique_hilbertPoly` verified present
  (`Mathlib.RingTheory.Polynomial.HilbertPoly`, `[CharZero]`, extraction half only —
  matches the strategy's careful "(ii) is only the EXTRACTION half" framing). The
  project's `gradedModule_hilbertSeries_rational` is correctly declared Mathlib-ABSENT
  (Stacks 00K1 is the inductive backing, confirmed in the reference index) — an
  honestly-named gap, not a phantom.
- **Effort honesty**: reasonable — QUOT-defs 4–7 / ~250–600, SNAP 2–4 / ~180–400,
  QUOT-repr 6–12 / ~400–1000+. The QUOT-repr band honestly carries "1000+" and is
  decomposed into GR-cells/glue/quot/repr with per-piece LOC; no "representability in
  ~30 LOC / 1 iter" dishonesty anywhere. SNAP's 2–4 for a from-scratch graded
  Hilbert–Serre rationality (S2) is optimistic-leaning but inside a plausible band.
- **Parallelism under-exploited**: no — the strategy explicitly routes all four QUOT
  files (Mathlib-only imports) and SNAP-S2 as parallel-authorable now.
- **Verdict**: CHALLENGE (localized to SNAP-S1; QUOT-defs and QUOT-repr are SOUND)

**Q4 (route polynomiality through graded Hilbert–Serre, not χ): SOUND IN
PRINCIPLE, but with one hidden-cohomology watch-point at S1.** Routing through
graded Hilbert–Serre rationality + `existsUnique_hilbertPoly` is the right
cohomology-free path and yields the same polynomial as the cohomological χ
(agreement for `m≫0`). The genuine risk the directive asks about lives entirely in
**S1** (`lem:sectionGradedModule_fg`, "H⁰ only"): for a coherent *quotient* `F`,
finite generation and the `m≫0` agreement of `⊕_m Γ(X_s, F_s⊗L_s^m)` is, in the
classical argument, controlled by `H¹` (H⁰ is only left-exact, so a surjection
`E ↠ F` does not surject on graded sections; the defect is `H¹`). To stay genuinely
cohomology-free, the graded Hilbert function MUST be taken on the *defining* f.g.
graded module `M` (the image of the chosen presentation `S^N → M`, f.g. by
Noetherianity), where `dim_κ M_m` agrees with `Γ(F_s⊗L^m)` for `m≫0` and — since
`Φ_s` depends only on `m≫0` — that substitution is legitimate. The strategy's prose
("the section module `⊕_m Γ(...)`, a f.g. graded module over the homogeneous
coordinate ring") is ambiguous about which object f.g.-ness is established on. The
planner must pin S1 to the graded-module presentation (Noetherian f.g.), NOT to a
sheaf-section finite-generation statement that silently needs `H¹` — otherwise a
cohomology dependency re-enters the Čech-independent leg through the back door.

**On QUOT-repr's RelativeSpec open question:** the `thm:relative_spec_univ`
strengthening (IsAffineHom → RepresentableBy) is a real open decision, but it is
handled acceptably — two concrete named options ("strengthen RelativeSpec, re-opens
proved work" vs "RepresentableBy-free GR-repr argument"), the Grassmannian-scheme
construction IS being built (GR-cells/glue/quot/repr decomposed with LOC), and it is
genuinely many iters downstream. This is an honest `## Open strategic questions`
entry, not infrastructure-deferral-by-inaction.

## Format compliance

- **Size**: 125 lines / ~7 KB — within budget (~250 lines / ~12 KB).
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`,
  `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical
  order. `## Completed` legitimately omitted (no phase is fully done — all
  ACTIVE/NEXT/BLOCKED).
- **Per-iter narrative detected**: yes — the active `## Phases & estimations` table
  carries iter references in prose cells: `"route swap landed iter-009 (mate tower
  dropped)"` (FBC-A Risks) and `"engine effort-broken iter-009 into 4 sub-lemmas"`
  (GF-alg Risks). These are exactly the "iter-XYZ pivot" references the canonical
  skeleton bars from STRATEGY.md (the only allowed bare-iter-number cell is the
  `## Completed` table's `Iters` column, which is not in play here).
- **Accumulation detected**: no — no completed phase stranded in the active table,
  no excised route lingering in `## Routes`.
- **Table discipline**: PASS — correct columns, short inline Status tags
  (`ACTIVE`/`NEXT`/`BLOCKED`), LOC cells are remaining-LOC ranges. (The per-iter
  narrative above is a content violation in the Risks cells, not a column-structure one.)
- **Format verdict**: DRIFTED

## Sunk-cost flags

(none — the strategy is forward-looking; the mate-tower drop and the willingness to
re-open proved RelativeSpec work are both anti-sunk-cost.)

## Prerequisite verification

- `Algebra.IsPushout.cancelBaseChange`: VERIFIED (`Mathlib.RingTheory.IsTensorProduct`,
  with `_tmul` / `_symm_tmul` rewrite lemmas).
- `Module.Flat.ker_lTensor_eq`: VERIFIED (`Mathlib.RingTheory.Flat.Equalizer`).
- `LinearMap.tensorEqLocusEquiv`: VERIFIED (same module; `_apply` +
  `lTensor_eqLocus_subtype_tensoreqLocusEquiv_symm` present).
- `Polynomial.existsUnique_hilbertPoly`: VERIFIED
  (`Mathlib.RingTheory.Polynomial.HilbertPoly`, `[Field F] [CharZero F]`, extraction half).
- `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`: VERIFIED
  (`Mathlib.RingTheory.Ideal.AssociatedPrime.Finiteness`).
- packaged `genericFlatness` / generic-freeness theorem: MISSING upstream (confirms
  GF-alg is real new material, not redundant).

## Must-fix-this-iter

- Route QUOT (SNAP-S1): CHALLENGE — pin `lem:sectionGradedModule_fg` to finite
  generation of the *defining graded module* `M` (Noetherian f.g.) with `dim_κ M_m`
  agreeing with `Γ(F_s⊗L^m)` for `m≫0`, NOT to a sheaf-section finite-generation
  statement that classically routes through `H¹`. Make the cohomology-free basis of
  S1 explicit in `## Mathlib gaps` (or the chapter), or rebut why the quotient
  presentation gives f.g. on graded sections directly. This is the one place a hidden
  cohomology dependency could re-enter the Čech-independent leg.
- Format: DRIFTED — strip the two `iter-009` per-iter-narrative phrases from the
  active Phases table Risks cells (e.g. "mate tower dropped; route = direct-on-sections"
  and "engine decomposed into 4 sub-lemmas"). Localized; fix in place this iter.

## Overall verdict

The strategy is in good shape: FBC and GF are SOUND with every named Mathlib
prerequisite verified present, the iter-009 FBC rewrite is now fully internally
consistent (no residual mate tower in prose, phases, or gaps), the FBC globalization
is genuinely Čech-cohomology-free, and the GF base-domain-generalizing induction
motive is correct with no hidden circularity. GF-alg is confirmed to be real new
material (no packaged generic-flatness upstream). The one substantive issue is in the
QUOT SNAP route: the strategy defers establishing the cohomology-freeness of S1
(finite generation of the section graded module "H⁰ only"), which is required for the
stated goal of keeping the Hilbert polynomial inside the Čech-independent leg — the
planner must pin S1 to the defining graded module rather than to sheaf-section finite
generation that classically needs `H¹`. Separately, STRATEGY.md is DRIFTED on format:
two `iter-009` per-iter-narrative references sit in the active Phases table and should
be excised in place. No REJECT, no infrastructure-deferral REJECT; one CHALLENGE
(QUOT-SNAP) plus the format fix.
