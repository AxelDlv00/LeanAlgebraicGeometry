# Progress Critic Directive

## Slug
iter125

## Iter
125

## Active routes / files under review

The iter-125 plan agent fired the iter-124-sharpened M2.a pivot
unconditionally on iter-124's PARTIAL outcome. M1 is now parked.
The only active prover-side route entering iter-125 is the
Rigidity refactor (a plan-phase refactor subagent dispatch, not a
prover lane). The next active prover route, **M2.a iter-126**, is
fresh and has no prior signal.

To support a clean read on the loop's recent convergence pattern,
review two routes:

### Route 1: M1.b — `AlgebraicJacobian/Differentials.lean:282` `IsAffineOpen.appLE_isLocalization`

- **Started at iter**: 122 (when M1.b was first opened as a sorry'd
  helper inside the iter-121 bridge scaffolding).
- **Iters audited**: 122–124 (inclusive).
- **Status entering iter-125**: PARKED.

#### Sorry counts per iter (project total)

- iter-122 close: 2 (Differentials L304 + Jacobian L179).
- iter-123 close: 2 (Differentials L362 + Jacobian L179).
- iter-124 close: 2 (Differentials L398 + Jacobian L179).

The Jacobian L179 sorry is off-limits (queued behind M2 + M3); the
relevant moving site is the Differentials.lean sorry which has
moved L304 → L362 → L398 across the three iters but never closed.

#### Helpers added per iter (top-level decls introduced)

- iter-122: 7 named declarations (`appLE_unitSubmonoid`,
  `appLE_colimRingHom`, `appLE_colimAlgebra`, `appLE_colimRingHom_comp_φV`,
  `isUnit_appLE_unitSubmonoid_in_colim`, `kaehler_localization_subsingleton`,
  `kaehler_quotient_localization_iso`) introduced as part of the
  plan-phase refactor that opened M1.b + sub-pieces.
- iter-123: 0 new top-level helpers; ~60 LOC of structural body
  reduction inserted in `appLE_isLocalization` body (Step 1 + Step
  4 closed in body).
- iter-124: 0 new top-level helpers; a single substantive Edit
  added the `forwardAlg` AlgHom (in-body), closed the `commutes'`
  field, and packaged the residual as
  `AlgEquiv.ofBijective forwardAlg sorry`.

#### Prover statuses per iter

- iter-122: PARTIAL (3 of 4 plan-phase-opened sorries closed; the
  M1.b body opened a new residual).
- iter-123: PARTIAL (Step 1 + Step 4 closed in body; Steps 2 + 3
  packaged into a single AlgEquiv hole).
- iter-124: PARTIAL (commutes' closed in body; residual narrowed
  from "the entire AlgEquiv" to "Function.Bijective ⇑forwardAlg").

#### Recurring blocker phrases

- "filtered-colim element representation" / "cocone universal
  property" / "no off-the-shelf colim-of-localizations lemma in
  Mathlib" — appeared in iter-122 task result, iter-123 task
  result, iter-124 task result. The iter-124 prover task result
  identified this as the residual Mathlib gap, with a concrete
  130–210 LOC closure recipe.
- "basic-open cofinality" — appeared as a forward-looking concern
  in iter-122 task result, surfaced as a concrete bottleneck only
  iter-124.

#### Decision context entering iter-125

The iter-124 strategy-critic CHALLENGEd this route's continuation
("sunk-cost re-emergence" — relabelling Step-1+Step-4-with-Step-3-
packaged as "Step 1+3+4 closure"). The iter-124 plan agent
responded with a sharpened iter-125 pivot trigger: "any PARTIAL
on iter-124's M1.b lane → unconditional M2.a pivot iter-125".
Iter-124 returned PARTIAL; the trigger fired. **iter-125 STRATEGY.md
parks M1 with the unparking recipe documented.**

Your question: was this the right call? Specifically:

- Was iter-124's M1.b a CHURNING route per your strict criterion
  (helpers added without residual shrinking)? Note: iter-123 and
  iter-124 added 0 new top-level helpers each — the pattern was
  in-body structural narrowing, not helper-multiplication. But
  the project sorry count was flat at 2 across iter-122 →
  iter-123 → iter-124, which IS the strict 3-iter-flat trigger.
- Is the iter-125 M1-park the right corrective, or should
  iter-126 attempt one more focused round on M1.b?

### Route 2: M2.a — Rigidity refactor (iter-125 plan-phase) + Rigidity prover lane (iter-126+)

- **Started at iter**: 125 (this iter).
- **Iters audited**: 125 only (fresh).
- **Status entering iter-125 prover phase**: scheduled. The iter-125
  plan-phase deliverable is the Rigidity refactor (subagent dispatch
  in plan phase); the iter-126 prover lane runs M2.a's body against
  the refactored declaration.

#### Sorry counts per iter

- iter-125 entry: 2 (Differentials L398 + Jacobian L179). Expected
  iter-125 close: 2 (refactor introduces no new sorries; existing
  sorries unchanged).
- iter-126 expected start: 2. Expected iter-126 close: 2 or 3
  (M2.a prover lane likely scaffolds a new `rigidity_over_kbar`
  declaration with a `sorry` body targeting C.2.d's
  "morphisms-from-ℙ¹-to-abelian-variety-are-constant" phantom).

#### Helpers planned

- iter-125: rename + signature refactor (`GrpObj.eq_of_eqOnOpen`
  → `Scheme.Over.ext_of_eqOnOpen`); no new helpers; -8 dropped
  hypotheses; weakened `[IsProper Y.hom]` → `[IsSeparated Y.hom]`.
- iter-126+: TBD; per Jacobian.tex § C.2 plan, the M2.a body is
  the C.2.b reduction to `Scheme.Over.ext_of_eqOnOpen` + the
  C.2.c image-dimension argument; C.2.d remains a phantom.

#### Prover statuses per iter

- iter-125: not a prover lane (plan-phase refactor only).
- iter-126: TBD.

#### Recurring blocker phrases

- None yet; this is a fresh route.

#### Decision context entering iter-125

The iter-124 mathlib-analogist
`rigidity-refactor-scoping-iter124` returned ALIGN_WITH_MATHLIB
on the refactored signature (drop 8 unused hyps; weaken
`[IsProper Y]` to `[IsSeparated Y]`; rename to mirror Mathlib's
`ext_of_isDominant_of_isSeparated'` naming). The persistent file
`analogies/rigidity-refactor.md` documents the rationale. Zero
project Lean consumers (the only callsite is the iter-126 M2.a
lane, not yet executed). 2 mechanical blueprint cross-ref updates
(`Rigidity.tex`, `Jacobian.tex` C.2.b).

Your question: is this UNCLEAR (fresh route, no signal) or should
it be CONVERGING (small, well-scoped, mechanical refactor)?

## Note on directive contents

Per your descriptor's strict context discipline, this directive
contains ONLY the per-route signals named above. It does NOT
include STRATEGY.md content, blueprint chapters, the full text of
iter sidecars, or recent prover task results. If you observe any
such pollution in this directive, ignore it.
