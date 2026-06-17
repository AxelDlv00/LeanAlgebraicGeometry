# Blueprint Reviewer Directive

## Slug
iter125

## Strategy snapshot

The project formalizes the nine protected declarations of Christian
Merten's Algebraic Jacobian Challenge bottoming out at
`AlgebraicGeometry.nonempty_jacobianWitness` (`Jacobian.lean:179`).
End-state: zero inline `sorry` in the project.

**Iter-125 strategic position (revised this plan phase)**:

- **M1 PARKED.** The `Differentials.lean` bridge `M1.b` residual at
  `IsAffineOpen.appLE_isLocalization` (line 282; sorry at L398) is
  parked iter-125 after three consecutive PARTIAL iters
  (iter-122 / iter-123 / iter-124) at flat project-sorry-count 2.
  The strategy section "M1 — Bridge … (PARKED from iter-125)"
  documents the parked state on disk + the concrete unparking recipe.
  STRATEGY.md must record M1 as parked, not as an active route.

- **M2.a active iter-125 → iter-126.** Iter-125 (this iter)
  executes the Rigidity refactor: rename
  `GrpObj.eq_of_eqOnOpen` → `Scheme.Over.ext_of_eqOnOpen` in
  `AlgebraicJacobian/Rigidity.lean`, drop 8 unused hypotheses,
  weaken `[IsProper Y.hom]` → `[IsSeparated Y.hom]`. The blueprint
  chapters `Rigidity.tex` (statement + uses) and `Jacobian.tex`
  (sub-step C.2.b on M2.a's reduction to the project's rigidity
  lemma) must be aligned to the refactored declaration name +
  signature. Iter-126 dispatches the M2.a prover lane against the
  refactored declaration.

- **M3 user-escalation outstanding.** `TO_USER.md` surfaces (i) the
  PR-and-wait alternative and (ii) the named-axiom alternative for
  the protected chain. The plan agent does NOT propose named axioms;
  user retains authority.

The two active blueprint-correctness questions for iter-125 are:

1. Does `Rigidity.tex` accurately describe the iter-125 refactored
   declaration (rename + dropped hypotheses + weakening)? The
   refactor lands DURING this iter's plan phase; the chapter must
   be updated to match. The plan agent inlines the chapter
   updates this iter — your job is to verify the alignment.

2. Does `Jacobian.tex` sub-step C.2.b's reference to
   `\thm:GrpObj_eq_of_eqOnOpen` accommodate the renamed
   `Scheme.Over.ext_of_eqOnOpen`? The body of C.2.b previously
   read "the cited theorem is stated for $X$ a smooth proper
   geometrically irreducible group scheme, whereas $\mathbb P^1_{\bar k}$
   is not a group scheme; however, the group-object structure on $X$
   is used in the proof of Theorem~\ref{thm:GrpObj_eq_of_eqOnOpen}
   \emph{only} to form a difference morphism …". This explanatory
   paragraph becomes obsolete with the refactor (the refactored
   declaration drops `[GrpObj X]`); the chapter prose needs to be
   updated by the plan agent inline this iter.

## Routes

Single critical-path route: **M2.a Rigidity refactor (iter-125) →
M2.a prover lane (iter-126) → M2.b genus-0 witness (iter-127) →
M2.c assembly (iter-128+) + M2.c.aux geometric-point witness +
M2.d-alt cotangent-vanishing (iter-130+)**.

Off-critical-path:
- **M1 (bridge `relativeDifferentialsPresheaf_equiv_kaehler_appLE`)
  PARKED**. The `Differentials.tex` chapter remains as a
  forward-looking sketch; the plan agent has added a remark
  `\rem:m1_parked_iter125` documenting the parked state with the
  concrete unparking recipe.
- **M3 user-escalation outstanding** on TO_USER.md.

## References

- `references/challenge.lean`: original AI-challenge file by
  Christian Merten; nine frozen-signature declarations decomposed
  into `AlgebraicJacobian/*.lean`. Authoritative for signatures.

## Focus areas

- **`Rigidity.tex`** — verify the chapter aligns with the iter-125
  refactored declaration (the plan agent inlines updates this iter).
- **`Jacobian.tex` § C.2.b (around L319–352)** — verify the
  refactored-declaration cross-references and the obsolete
  "group-object-on-source" explanatory paragraph are addressed.
- **`Differentials.tex` § M1.b proof of `lem:appLE_isLocalization`
  + the new `\rem:m1_parked_iter125` (added this iter, just after
  the proof of `lem:appLE_isLocalization`)** — verify the parked
  recipe is documented adequately for M1's unparking.

## Known issues

- Four orphan chapters (`Modules_Monoidal.tex`, `Picard_Functor.tex`,
  `Picard_FunctorAb.tex`, `Picard_LineBundle.tex`) describe Lean
  files that no longer exist (`Modules/Monoidal.lean` and
  `Picard/*` paths). The iter-124 blueprint-reviewer flagged this as
  informational (severity); they are NOT included in `content.tex`
  and do not block any prover. **Cleanup is a future-iter
  candidate; not iter-125 blocking.**

- 5 inline-only references in `Differentials.tex`
  (`appLE_unitSubmonoid`, `isUnit_appLE_unitSubmonoid_in_colim`,
  `appLE_colimRingHom_comp_φV`, `appLE_colimRingHom`,
  `appLE_colimAlgebra`) have `\lean{...}` references but no
  dedicated `\begin{lemma}` / `\begin{definition}` blocks. The
  iter-124 blueprint-reviewer flagged this as a soon item; the
  M1.a / M1.b parking position iter-125 means this is even less
  urgent now (parked routes don't need lemma-block promotion).
  Carry forward.
