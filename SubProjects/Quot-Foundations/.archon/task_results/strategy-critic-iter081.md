# Strategy Critic Report

## Slug
iter081

## Iteration
081

## Routes audited

### Route: FBC — DIRECT H⁰-equalizer (primary; mate keystone ABANDONED)

- **Goal-alignment**: PASS — the two named legs (`flatBaseChange_pushforward_isIso`,
  `affineBaseChange_pushforward_iso`) have frozen signatures and free bodies, so the direct route
  discharges exactly the goal declarations. The frozen signature *is* the canonical base-change
  comparison map, so the classic "abstract iso ≠ canonical-map iso" trap is structurally guarded:
  filling the frozen body forces `IsIso` of the specific natural transformation, not a free-standing
  equivalence.
- **Mathematical soundness**: PASS — `H⁰(X,F)=Γ(X,F)` as the finite equalizer `∏Γ(Uᵢ)⇉∏Γ(Uᵢⱼ)` over a
  finite affine cover, with flat `−⊗B` preserving that finite equalizer, is precisely Stacks 02KH(2).
  The module core is reported DONE 0-sorry and the keystone Mathlib lemma is real (see Prerequisite
  verification). The only residual is sheaf-level: per-chart 01I9 identification of the base-changed legs
  with `g'^*F` + global assembly — a real but bounded step.
- **Sunk-cost reasoning detected**: no — this is the *opposite*. The mate keystone (4 sorries in
  `FlatBaseChange.lean`) was abandoned at a kill-criterion and replaced by a route whose hardest
  prerequisite (`flat preserves finite equalizer`) is already in Mathlib. The pivot changes the hard
  prerequisite (project-side adjoint/conjugate juggling → a present Mathlib lemma) rather than relocating
  it, and the new hard prereq is already discharged 0-sorry. This is a genuine pivot, not avoidance.
- **Infrastructure-deferral detected**: no.
- **Effort honesty**: reasonable — 2–4 iters / ~150–350 LOC for "scaffold+prove one lemma, discharge two
  frozen bodies" is consistent with the completed FBC RegroupHelper velocity.
- **Verdict**: CHALLENGE — not for the route itself (sound) but for the **stale `## Routes` preamble**
  that still describes the pre-pivot world; see Must-fix. The disposal of the 4 FBC-A sorries (fill 2 via
  FBC-B, delete 2 dead `mate_*` lemmas) is correctly scoped but has no tracked row, while "zero project
  sorry" is the goal — the delete-lane should be an explicit cleanup row, not just prose.

### Route: GF — generic flatness

- **Verdict**: SOUND. Algebraic core and the geometric wrapper are both in `## Completed`
  (`genericFlatnessAlgebraic` 022, `genericFlatness` 059), the ring-epi final-gap route is closed, and
  the Mathlib anchors it names (`TensorProduct.lid'`, `CommRingCat.epi_iff_epi`, `Spec.fullyFaithful`,
  `Module.Flat.baseChange/.of_linearEquiv`) are standard. Nothing live to challenge.

### Route: QUOT — Hilbert poly / Quot functor / Grassmannian / representability

- **Goal-alignment**: PARTIAL — the H⁰ graded-Hilbert-function `Φ_s` encoding of `def:hilbert_polynomial`
  is sound *in isolation* and sufficient for the Grassmannian (`Grassmannian := QuotFunctor (𝟙 S) V Φ_d`,
  where the quotient is locally free of constant rank `d`, so H⁰ and χ coincide). But the Goal demands
  "names/labels matching the parent so the work merges back," and the strategy has **not confirmed the
  parent's `def:hilbert_polynomial` is H⁰-semantic rather than χ-semantic**. In FGA/Nitsure the Quot
  Hilbert polynomial is the Euler characteristic χ(F(m)); only χ is locally constant in flat families,
  H⁰ alone is not. If the parent node means χ, an H⁰-`Φ_s` definition is a *semantically different*
  declaration wearing the parent's label — the merge-back would silently change the theorem, not close
  the node. The strategy's own framing ("Čech-independent leg", "χ unreachable here") is a plausible
  defence (the cohomology-heavy χ machinery lives in a sibling leg and this leg only owes the
  H⁰/constant-rank piece), but that compatibility is *assumed, not verified*.
- **Mathematical soundness**: PASS — the rationality engine (`gradedModule_hilbertSeries_rational`,
  Stacks 00K1, Route 2) is done axiom-clean; `existsUnique_hilbertPoly` is verified present; the Q3
  standard-graded fence is correctly identified.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no (strict bar) — but see Parallelism: `RelativeSpec` is a
  goal-required, genuinely project-side construction (absent from Mathlib) with a project plan but no
  decomposed timeline and no active lane.
- **Phantom prerequisites**: none — `existsUnique_hilbertPoly` and the GF/FBC anchors all verify.
- **Effort honesty**: reasonable for GR-quot (1–3 iters / ~350–700 LOC tracks the realized ~600 LOC / 2
  iters of GR-cells) and SNAP. QUOT-repr's 6–12 iters / ~400–1000+ LOC bundles *three* substantial
  sub-builds (Grassmannian-of-quotients as a scheme; the relative Spec construction + universal property;
  functor-of-points representability) into one BLOCKED row — wide enough to be honest, but it is the row
  most likely to balloon and the least decomposed.
- **Parallelism under-exploited**: yes — `RelativeSpec` (its own chapter `Picard_RelativeSpec`, a real
  construction not in Mathlib) is serialized *inside* the BLOCKED QUOT-repr row behind GR-quot and SNAP,
  despite depending on neither the tautological quotient nor the section graded ring. It could be a fourth
  active lane now (after pinning the Q4 tag), shaving QUOT-repr's critical path.
- **Verdict**: CHALLENGE — the H⁰-vs-χ *merge-back semantics* must be confirmed (not just signatures),
  and `RelativeSpec` should be pulled out as an independent lane rather than serialized.

## Format compliance

- **Size**: 140 lines / ~9.4 KB — within budget (~250 lines / ~12 KB).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`,
  `## Open strategic questions`, `## Mathlib gaps & new material`, in order; `## Completed` correctly
  sits between Phases and Routes.
- **Per-iter narrative detected**: yes — iter numbers appear in *prose* (not the Completed ledger cell):
  `Q2 — FBC keystone _legs_conj — RESOLVED by route swap (iter-079)`, `C2 + universalQuotient CLOSED
  iter-064`, `The proof was reduced (iter-055) to a single per-piece flatness`, `gap1 landed iter-044`.
  These are history-tracking and belong in iter sidecars.
- **Accumulation detected**: yes (mild) — (a) the `## Routes` preamble is **stale**: "FBC-A, GF-geo, and
  QUOT-consumers are the live frontier. FBC-B follows FBC-A" contradicts the adopted pivot (FBC-A
  ABANDONED, FBC-B is the primary active route and does *not* follow FBC-A) and the Completed table
  (GF-geo and QUOT-consumers are DONE, not frontier); (b) FBC-A, an ABANDONED/OFF-PATH route, still
  occupies a full active-Phases row — it could compress to a one-line disposal note.
- **Table discipline**: FAIL (drift) — the active-Phases `Risks` cells carry multi-sentence paragraphs
  (e.g. FBC-B and SNAP Risks are ~5–6 sentences each), not "one short line per cell."
- **Format verdict**: DRIFTED

## Alternative routes (suggested)

### Alternative: Promote RelativeSpec to an independent active lane

- **What it looks like**: split `RelativeSpec` (the relative-Spec construction + its `RepresentableBy`
  universal property, `thm:relative_spec_univ`) out of the BLOCKED QUOT-repr row into its own ACTIVE row,
  started in parallel with GR-quot/SNAP once the Q4 Stacks tag is pinned.
- **Why it might be cheaper or sounder**: it has no dependency on GR-quot's tautological quotient or
  SNAP's section graded ring; serializing it behind them implicitly adds its iters to the critical path.
  It is genuine work (Mathlib has absolute `Spec` only, no relative Spec of a sheaf of algebras with a
  representability statement — verified), so parallelising it is pure throughput.
- **What the current strategy may have rejected**: unclear — the strategy folds it into QUOT-repr without
  comment; likely just never decomposed rather than deliberately serialized.
- **Severity of the omission**: major

## Prerequisite verification

- `LinearMap.tensorEqLocusEquiv`: VERIFIED — `Mathlib.RingTheory.Flat.Equalizer` (with companion
  `lTensor_eqLocus_subtype_tensoreqLocusEquiv_symm` confirming the equiv is the canonical `lTensor`-of-
  subtype map, i.e. canonical-map-compatible). The strategy's "(Mathlib, present)" is correct.
- `Polynomial.existsUnique_hilbertPoly`: VERIFIED — `Mathlib.RingTheory.Polynomial.HilbertPoly`, needs
  `[Field F] [CharZero F]`, power-series-coefficient agreement form (matches the project's `IsRatHilb`).
  The strategy's `[CharZero]` note is correct.
- relative Spec of a sheaf of algebras (for `thm:relative_spec_univ`): MISSING from Mathlib — only
  absolute `Spec` exists. Confirms `Picard_RelativeSpec` is real project-side construction work, not a
  re-export. (Not a phantom *assumed* by the strategy — it's listed as project material — but it sizes
  the QUOT-repr row.)

## Must-fix-this-iter

- Route FBC: CHALLENGE — the `## Routes` preamble is stale and self-contradictory ("FBC-A … live
  frontier. FBC-B follows FBC-A" vs. the adopted abandonment). Rewrite it to reflect FBC-B as the primary
  active route and FBC-A as abandoned; this stale prose will misdirect the plan agent every iter.
- Route QUOT: CHALLENGE — confirm the parent's `def:hilbert_polynomial` is H⁰-`Φ_s`-semantic, not
  χ-semantic, before building more SNAP/S1 infra. Sharpen the "Merge-back signature check" open question
  to cover *semantic* match (H⁰ vs χ), not just signature shape. If the parent means χ, the H⁰ encoding
  is a goal-weakening dressed as a scoping decision.
- Alternative RelativeSpec: major omission — pull `RelativeSpec` out of the BLOCKED QUOT-repr row into an
  independent lane (it is goal-required, project-side, Mathlib-absent, and dependency-free w.r.t.
  GR-quot/SNAP).
- Format: DRIFTED — remove per-iter narrative from prose (iter-044/055/064/079 references), compress the
  abandoned FBC-A row to a one-line disposal note, and shorten the multi-sentence `Risks` cells to one
  line. Move any needed history to iter sidecars.

## Overall verdict

The strategy's core mathematics is sound and its two most load-bearing Mathlib prerequisites
(`tensorEqLocusEquiv`, `existsUnique_hilbertPoly`) are verified present, so neither active route rests on
phantom infrastructure. The FBC route swap is a *genuine* pivot, not sunk-cost avoidance: it replaces a
project-side adjoint-juggling prerequisite with a Mathlib lemma that is already discharged 0-sorry, and
the frozen target signatures structurally force the canonical comparison map. The four ACTIVE/BLOCKED
rows are scoped honestly. Two substantive issues must be addressed this iter: (1) the `## Routes`
preamble is stale and contradicts the adopted FBC pivot and the Completed ledger — a live misdirection;
(2) the Q1 H⁰-`Φ_s` vs χ choice is sound *in isolation* but its parent merge-back semantics are assumed,
not verified — if the parent's `def:hilbert_polynomial` means the Euler characteristic, the H⁰ encoding
silently changes the theorem rather than closing the node, so the merge-back check must be sharpened from
signature-only to semantic. Separately, `RelativeSpec` — required by the goal and absent from Mathlib —
is serialized behind GR-quot/SNAP despite being independent of both, an exploitable parallelism win.
Format has drifted (per-iter narrative in prose, long Risks cells, an abandoned route still holding an
active row) but the skeleton is structurally intact.
