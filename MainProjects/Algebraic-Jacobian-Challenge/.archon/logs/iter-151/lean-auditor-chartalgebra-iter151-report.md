# Lean Audit Report

## Slug
chartalgebra-iter151

## Iteration
151

## Scope
- files audited: 1 — `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (per directive)
- files skipped (per directive): all others — directive narrowed scope to this single file.

Verification basis: `lean_diagnostic_messages` (two `sorry` warnings: L256, L507),
`lean_verify` on the downstream consumer, and a project-wide grep for consumers of
each declaration in this file.

---

## Per-file checklist

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 3 flagged
- **suspect definitions**: 2 flagged (one KNOWN-FALSE `sorry`, one silent false-propagating consumer)
- **dead-end proofs**: 2 flagged (orphaned `_mvPoly_*`/`_finsupp` chain; dead in-body scaffolding)
- **bad practices**: 2 flagged (iter-narrative comment bloat; misleading lemma name)
- **excuse-comments**: 1 flagged (knowingly-false retained `sorry`, L418–422)
- **notes** (per declaration):

  - **L88 `GrpObj.algebra_isPushout_of_affine_product`** — closed by `inferInstance`. Sound
    Lean. Only consumers found are comment references (no compiled use anywhere in the project);
    a legitimate re-export naming the Mathlib pushout instance, so harmless. Minor: possibly
    orphaned, but not wrong.
  - **L117 `_finsupp_sub_single_eq_of_one_le`** — genuinely closed (no `sorry`/`admit`,
    non-vacuous). Used only by `_mvPoly_coeff_pderiv_at_shifted`. Transitively DEAD (see L215).
  - **L133 `_mvPoly_coeff_pderiv_at_shifted`** — genuinely closed; real coefficient-formula
    proof. Used only by `_mvPoly_mem_range_C_of_pderiv_eq_zero`. Transitively DEAD.
  - **L175 `_mvPoly_mem_range_C_of_pderiv_eq_zero`** — genuinely closed; real support-analysis
    proof. Used only by `_mvPoly_mem_range_C_of_D_eq_zero`. Transitively DEAD.
  - **L215 `_mvPoly_mem_range_C_of_D_eq_zero`** — genuinely closed (sorry-free). **ORPHANED**:
    referenced ONLY in comments (L305, L307, L322), never as a compiled term. It is `private`,
    so no out-of-file consumer is possible. This makes the whole `_mvPoly_*`/`_finsupp` chain
    (L117–225, ~110 LOC) dead from the project's perspective.
  - **L256 `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`** — ends in `sorry` (L422)
    under a signature the author has independently concluded is **FALSE**. See must-fix #1.
    All in-body scaffolding (`_hRev`, `_hStdSm`, `_hFree`, `_basis`, `_hCoordVanish`,
    `_hπSurj`, `bTilde`, `_hFunct`, L265–360) typechecks as genuine proof (no hidden sorry),
    but is DEAD: the goal is discharged by `sorry`, so none of it is load-bearing.
  - **L450 `GrpObj.df_zero_factors_through_constant_on_chart`** — closed by a *direct term
    application* of the false L256 lemma. `lean_verify` confirms it depends on `sorryAx` yet
    emits NO `sorry` warning of its own. See must-fix #2.
  - **L507 `constants_integral_over_base_field`** — one live `sorry` at L651 (the `(b.2)
    IsPurelyInseparable` branch); the `(b.1)` separability branch is genuinely closed. This is
    ordinary structured WIP (NOT claimed false), distinct from the L256 case. See major.
  - **L720 `Scheme.Over.ext_of_diff_zero`** — closed by delegation to
    `Rigidity.ext_of_eqOnOpen`. Sound, but the NAME is misleading: it promises a "diff = zero"
    hypothesis that is absent from the signature (which takes `eqOnOpen` directly). Docstring
    is honest about the rename. See major.

---

## Must-fix-this-iter

- **`AlgebraicJacobian/Cotangent/ChartAlgebra.lean:422`** — `sorry` retained under
  `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`, a load-bearing lemma the author's
  own L361–421 comment block concludes is **mathematically false as stated**.
  Why must-fix: a `sorry` asserts "true, proof pending" and lets the kernel admit the
  declaration so downstream code may use it. When the statement is known-false, the `sorry`
  becomes a live assertion of a false theorem. I independently verified the author's reasoning
  and it holds (see assessment below) — so this is not a provability gap, it is a wrong
  signature. The correct hygiene is to fix the signature now (add the geometric hypothesis the
  author identified — `k` algebraically closed in `B` / geometric-connectedness premise), NOT
  to keep a `sorry`. Note the signature is **not** listed in `archon-protected.yaml`, so the
  in-body "frozen-by-blueprint" justification for leaving it false does not hold — agents are
  permitted to correct it.

- **`AlgebraicJacobian/Cotangent/ChartAlgebra.lean:450`** —
  `df_zero_factors_through_constant_on_chart` consumes the false L256 lemma as its entire
  proof. `lean_verify` reports its axiom set includes `sorryAx`, yet it compiles with **no
  `sorry` warning**. Why must-fix: this launders a known-false statement into a clean-looking
  theorem; any future consumer of `df_zero_factors_through_constant_on_chart` inherits the
  falsehood with zero visible signal. Until L256 is corrected, this consumer must not present
  as a closed theorem (it should either carry its own explicit `sorry`, or be corrected in
  lockstep with L256). Blast radius is currently bounded — grep shows no consumers outside this
  file and `ChartAlgebraS3.lean` (comment-only) — but the laundering pattern is the hazard.

## Major

- **`ChartAlgebra.lean:117–225`** — the `_finsupp_sub_single_eq_of_one_le` →
  `_mvPoly_coeff_pderiv_at_shifted` → `_mvPoly_mem_range_C_of_pderiv_eq_zero` →
  `_mvPoly_mem_range_C_of_D_eq_zero` chain (~110 LOC of genuine, sorry-free proof) is
  **orphaned dead code**: the chain's apex is referenced only in comments. Its sole stated
  purpose was to feed the L422 "transfer step" of a lemma now diagnosed false. The helpers are
  correct and reusable, but as committed they are unused and their justification no longer
  holds. Either wire them into a corrected lemma or remove them; do not leave them as
  comment-justified dead weight.

- **`ChartAlgebra.lean:651`** — live `sorry` in `constants_integral_over_base_field` (the
  `(b.2) IsPurelyInseparable k Γ` branch). This is legitimate structured WIP, not a wrong/false
  claim, so it is classified major rather than must-fix; flagged because it is a live sorry on a
  substantive claim that downstream work depends on.

- **`ChartAlgebra.lean:720`** — `Scheme.Over.ext_of_diff_zero` is named for a "diff = zero"
  hypothesis that does not appear in its signature (it takes `eqOnOpen` directly and is a thin
  rename of `ext_of_eqOnOpen`). The name misrepresents the actual hypotheses to any reader who
  does not read the docstring. Naming drift on a public theorem.

## Minor

- **`ChartAlgebra.lean:262–360`** — the `_hRev`/`_hStdSm`/`_hFree`/`_basis`/`_hCoordVanish`/
  `_hπSurj`/`bTilde`/`_hFunct` scaffolding is dead (proof closes via `sorry` at L422). It
  typechecks as real proof content (the directive's question 2: yes, `_hFunct` and the
  `(C.a)–(C.c)` steps are genuinely closed — no hidden `sorry`/`admit`, no vacuous/tautological
  bodies), but contributes nothing to the current compiled term.

- **`ChartAlgebra.lean:15–66, 39–66, 234–255, 297–337, 461–467`** etc. — pervasive
  iter-by-iter narrative comments ("iter-145 NOTE", "iter-146 prover lane", "Iter-149 signature
  inflation", "HYBRID part (C) approach (iter-150)"). These document process, not code, and
  several are already stale (e.g. L20, L59 reference `: True := sorry` placeholders that no
  longer exist in the file). Code-smell / maintenance burden; bias toward moving this into the
  blueprint or task journal.

- **`ChartAlgebra.lean:88`** — `algebra_isPushout_of_affine_product` appears unused (only
  comment references project-wide). Harmless re-export; noted for completeness.

## Excuse-comments (always called out separately)

- **`ChartAlgebra.lean:418–422`** (attached to `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`):
  > "The `sorry` is retained (rather than a weakened/tautological body) so the intended —
  > though currently FALSE — signature is preserved verbatim for the mathematician's
  > signature-correction decision …"

  Severity: **critical**. This is worse than a generic "TODO/placeholder" excuse-comment: it is
  an explicit, in-code admission that the project is holding a `sorry`-backed theorem the author
  *knows* is false, and a live downstream consumer (L450) depends on it. The intent (preserve
  the signature for the mathematician) is defensible, but `sorry` is the wrong mechanism — it
  makes the false statement consumable. The honest encodings are (a) correct the signature now,
  or (b) if deferring, ensure no clean-compiling consumer depends on it.

---

## Independent assessment of the L361–421 "lemma is false" comment (directive focus area 1)

**The comment's reasoning holds up.** Both counterexamples are valid:

- **CE1** (`B = k × k`, `n = 0`): `k × k` is finite étale over `k`, i.e. standard smooth of
  relative dimension 0 — so `Algebra.IsStandardSmoothOfRelativeDimension 0 k (k×k)` holds, and
  every other hypothesis (`Field k`, `CharZero k`, `Algebra.FiniteType k B`) holds. Étale ⇒
  `Ω[B⁄k] = 0` ⇒ `D = 0` ⇒ `hDb` holds for every `b`. But `range (algebraMap k (k×k))` is the
  diagonal `{(c,c)}`, and `(1,0)` is not in it. Genuine counterexample.
- **CE2** (`k = ℚ`, `B = ℚ(√2)`, `n = 0`): a finite separable field extension is étale ⇒
  standard smooth of relative dimension 0; `Ω[B⁄k] = 0` ⇒ `D = 0` ⇒ `hDb` holds for every `b`;
  but `range (algebraMap ℚ ℚ(√2)) = ℚ ⊊ ℚ(√2)`. Genuine counterexample (and it defeats any
  "B is a domain / Spec B connected" patch — connectedness is not enough; one needs `k`
  algebraically closed in `B`).

The diagnosis is also correct: `IsStandardSmoothOfRelativeDimension n k B` is "∃ submersive
presentation of dimension n" and carries no connectedness / geometric-irreducibility data, which
is exactly what a true "ker D = range(algebraMap k B)" statement requires.

**Is retaining the `sorry` the right Lean hygiene? No.** A `sorry` is a promissory note that the
statement is true and provable. Once the author has *concluded the statement is false*, the
`sorry` stops being a TODO and becomes a kernel-admitted false theorem that a live consumer
(L450) silently absorbs (verified: `sorryAx` in its axiom set, no warning). The right actions,
in order of preference: (1) correct the signature this iter (the lemma is not in
`archon-protected.yaml`, so this is permitted); (2) if the correction must wait for the
mathematician's geometric-hypothesis decision, do not leave a clean-compiling downstream
consumer depending on it — quarantine the false lemma. A 60-line comment does not neutralise a
kernel-admitted falsehood. The `_mvPoly_*` helpers and `_hFunct` scaffolding are indeed valid
and reusable for the *corrected* lemma — that part of the comment is accurate — but they should
live attached to a true statement, not a false one.

---

## Severity summary

- **must-fix-this-iter**: 2 — L422 (known-false `sorry` on load-bearing lemma) and L450 (silent
  `sorryAx`-laundering consumer). These block downstream work until L256's signature is corrected.
- **major**: 3 — orphaned `_mvPoly_*`/`_finsupp` chain (L117–225); live WIP `sorry` (L651);
  misleading name `ext_of_diff_zero` (L720).
- **minor**: 3 — dead in-body scaffolding (L262–360); iter-narrative/stale comment bloat;
  unused `algebra_isPushout_of_affine_product` (L88).
- **excuse-comments**: 1 (also counted under must-fix above) — the "currently FALSE signature
  preserved verbatim" comment at L418–422; critical, because it documents the project knowingly
  retaining a false `sorry`-backed theorem with a live consumer.

Overall verdict: the file compiles, and the `_mvPoly_*`/`_hFunct` scaffolding the directive asks
about is genuinely sorry-free and non-vacuous — but it is orphaned, and the central lemma carries
a `sorry` under a signature the author has correctly diagnosed as false while a downstream
theorem silently consumes it; correcting (or quarantining) that false lemma is the must-fix.
