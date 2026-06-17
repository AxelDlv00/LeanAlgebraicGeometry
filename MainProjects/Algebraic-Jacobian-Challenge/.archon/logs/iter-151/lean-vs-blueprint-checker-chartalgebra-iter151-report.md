# Lean ↔ Blueprint Check Report

## Slug
chartalgebra-iter151

## Iteration
151

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex` (§ "Chart-algebra piece (ii)
  first-class decomposition", subsec at L1842; KDM block L2326–2439)

Directive focus: the KDM lemma
`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` and its route-(C)/(BR.5′)
(C.a)–(C.d) prose. All five `\lean{...}`-tagged declarations of the file are
covered below; KDM is treated in depth.

## Per-declaration

### `\lean{AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero}` (thm: `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`, blueprint L2326)
- **Lean target exists**: yes — `ChartAlgebra.lean:256`.
- **Signature matches**: **yes**. Lean: `{k} [Field k] [CharZero k] {B} [CommRing B]
  [Algebra k B] [Algebra.FiniteType k B] {n} [IsStandardSmoothOfRelativeDimension n k B]
  {b} (hDb : D k B b = 0) : b ∈ (algebraMap k B).range`. The blueprint statement block
  (L2348–2351) says exactly "k a field, B a finite-type / standard-smooth-of-relative-
  dimension-n k-algebra, D b = 0 ⟹ b ∈ range(algebraMap k B)", and the live-route
  paragraph (L2357) explicitly records the `[CharZero k]` carried in the Lean signature.
  No predicate mismatch.
- **Proof follows sketch**: **N/A — open**. Lean body carries a `sorry` at
  `ChartAlgebra.lean:422`. Sub-steps (C.a)–(C.c) ARE present and closed in Lean
  (the four `_mvPoly_*` private lemmas + the `_hFunct` functoriality reduction),
  matching the blueprint (C.a)–(C.c) bullets faithfully. The residual `sorry` sits
  exactly at the (C.d) transfer step, as the blueprint says.
- **notes**: The Lean inline comment (L361–421) asserts the lemma is **FALSE as
  stated** under its own hypotheses, with two counterexamples (CE1 = `k×k`, n=0,
  finite étale; CE2 = `ℚ ⊂ ℚ(√2)`, n=0, finite separable). The iter-151 review
  has propagated this finding into the blueprint: a `% NOTE (iter-151, review)`
  at the statement block (L2331–2347) carries the SAME two counterexamples and the
  same diagnosis (missing geometric hypothesis: "k algebraically closed in B"), and
  a second `% NOTE` at the (C.d) bullet (L2364–2369) marks the (S5.a)/(S5.b) closure
  prose as UNREACHABLE. **The Lean comment and the blueprint NOTEs now agree.** The
  prior iter-150 prose-vs-Lean divergence (blueprint promising (C.d) closable) has
  been corrected by annotation rather than deletion — the stale (C.d)/(S5.a)/(S5.b)
  prose (L2370) is retained but explicitly bracketed as "the shape of the proof FOR
  THE CORRECTED (geometrically-integral) lemma only".

### `\lean{AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product}` (lem, L1849)
- **Lean target exists**: yes — `ChartAlgebra.lean:88`.
- **Signature matches**: yes (algebra-level `Algebra.IsPushout k B₁ B₂ (B₁ ⊗[k] B₂)`).
- **Proof follows sketch**: yes — closed by `inferInstance`; the blueprint NOTE
  (L1858–1873) honestly documents that the three-step scheme-level chain collapses to
  one instance resolution at the algebra level.
- **notes**: clean, closed, marker-honest.

### `\lean{AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart}` (thm, L1898)
- **Lean target exists**: yes — `ChartAlgebra.lean:450`.
- **Signature matches**: partial-by-design — the Lean keeps `(k, C with
  IsProper/Smooth/IsReduced/GeometricallyIrreducible, B finite-type, b, hDb)` and
  drops the chart-pair data `(W,V,f♯,A,f,df=0)`; the iter-148 blueprint NOTE
  (L1903–1923) documents this thin-wrapper disposition explicitly.
- **Proof follows sketch**: no — body is a one-line delegate to KDM (L468), not the
  five-step Čech/Mayer–Vietoris recipe of the blueprint proof. Documented as deferred.
- **notes**: **Transitive consequence of the KDM finding** — this theorem has no
  `sorry` of its own but routes entirely through KDM, so it currently rests on KDM's
  false-as-stated `sorry`. Notably, the geometric content KDM is missing
  (`GeometricallyIrreducible (C ↘ Spec k)` + `IsReduced C`) is PRESENT in this
  theorem's hypotheses (L455–456) but discarded by the one-line delegate. This is the
  concrete location of the architectural fix: thread that geometric data into KDM.

### `\lean{AlgebraicGeometry.constants_integral_over_base_field}` (lem, L2193)
- **Lean target exists**: yes — `ChartAlgebra.lean:507`.
- **Signature matches**: yes (`RingHom.range (appTop.hom) = ⊤` for smooth proper
  geom-irr reduced X over a field).
- **Proof follows sketch**: partial — substeps (1)–(2) and the (b.1) separable branch
  are closed; the (b.2) `IsPurelyInseparable` branch carries a `sorry` at
  `ChartAlgebra.lean:651` (depends on the `ChartAlgebraS3.lean` Lane-1 sorries
  `(S3.pi.*)`). Out of this directive's KDM scope, but flagged for completeness.
- **notes**: pre-existing structured sorry, not introduced/altered by the KDM work.

### `\lean{AlgebraicGeometry.Scheme.Over.ext_of_diff_zero}` (thm, L2441)
- **Lean target exists**: yes — `ChartAlgebra.lean:720`.
- **Signature matches**: yes (thin renaming of iter-125 `ext_of_eqOnOpen`).
- **Proof follows sketch**: yes for the committed disposition — delegates to
  `ext_of_eqOnOpen`; blueprint NOTE (L2446+) documents the dropped `df=dg` derivation.
- **notes**: closed, marker-honest.

## Red flags

### Placeholder / suspect bodies
- `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` at `ChartAlgebra.lean:422`:
  body is `sorry` on a declaration the blueprint marks as a substantive `\begin{theorem}`.
  **Per the verbatim severity rules this is a must-fix-this-iter trigger.** The mitigating
  circumstance (and the correct disposition): the lemma is **mathematically false** under
  its frozen-by-blueprint hypotheses, so the corrective is NOT a prover decomposition but
  an *architectural signature change*, already escalated to the user (couples to the
  `[IsAlgClosed kbar]` / geometric-irreducibility decision). The Lean comment correctly
  identifies this as the bright-line STUCK trigger (pivot / user-escalation). Retaining the
  verbatim signature under `sorry` (rather than weakening to a true-but-vacuous body) is the
  right call for the mathematician's signature-correction decision.
- `constants_integral_over_base_field` at `ChartAlgebra.lean:651`: `sorry` on the (b.2)
  branch. Pre-existing, out of KDM scope; listed for the per-file record.

### Marker discrepancy (proof-block `\leanok`)
- `RigidityKbar.tex:2356`: the KDM **proof block** carries `\leanok`, which by the project
  marker vocabulary means "proof closed, no sorry". The Lean proof has a `sorry`
  (`ChartAlgebra.lean:422`), so this proof-block `\leanok` is **false**. `\leanok` is
  sync_leanok-managed (not an agent's write domain), so this is a sync/staleness issue to
  surface, not an agent edit — but it actively advertises a false-and-incomplete proof as
  complete, directly alongside the new iter-151 NOTE saying the opposite. Flag for the
  sync phase to re-run / for the plan agent's awareness. (The statement-block `\leanok` at
  L2326 is acceptable: a formalized declaration with a `sorry` present legitimately gets the
  statement-level marker.)

### Excuse-comments
None that are illegitimate. The "false as stated" inline block (L361–421) and the blueprint
NOTEs are not excuse-comments for wrong code — they are an accurate, counterexample-backed
diagnosis escalating an architectural defect, which is exactly the workflow the bright-line
rules prescribe. They are the honest disposition, not a red flag.

### Axioms / Classical.choice
None.

## Unreferenced declarations (informational)
- `_finsupp_sub_single_eq_of_one_le`, `_mvPoly_coeff_pderiv_at_shifted`,
  `_mvPoly_mem_range_C_of_pderiv_eq_zero`, `_mvPoly_mem_range_C_of_D_eq_zero` — `private`
  helpers for (C.a). Correctly referenced in prose as project-internal lemmas (blueprint
  (C.a) bullet, L2361) without `\lean{...}` blocks. Acceptable as helpers.

## Blueprint adequacy for this file
- **Coverage**: 5/5 substantive Lean declarations carry a `\lean{...}` block in the
  RigidityKbar.tex piece-(ii) subsection. The 4 `_mvPoly_*` / finsupp helpers are
  private and prose-referenced. No orphans.
- **Proof-sketch depth**: adequate (now). The (C.a)–(C.d) itemisation matches the Lean
  structure 1:1; the FREE-CASE coefficient argument of (C.a) is sketched in enough detail to
  reproduce the Lean helpers. The previously-misleading (C.d) closure claim is now correctly
  flagged unreachable.
- **Hint precision**: precise. The `\lean{...}` name matches; `[CharZero k]` is named in the
  prose; the standard-smooth predicate is pinned.
- **Generality**: **too narrow / wrong (the lemma's own signature)** — this is the core
  finding. The blueprint statement (and hence the frozen Lean signature it guided) omits the
  geometric-connectedness hypothesis ("k algebraically closed in B"). The blueprint mis-guided
  the original formalization by asserting a false closure path (the iter-148/149 (BR.*) and
  iter-150 (C.d) prose all claimed closability). The iter-151 review NOTEs now correct this
  in-place and are **sufficient to warn a future reader/prover**: a reader hitting the
  statement block sees the false-as-stated NOTE first, and a prover reaching (C.d) sees the
  "UNREACHABLE" NOTE immediately above the bullet. Both name the counterexamples and the fix.
- **Missing dedicated `..._ChartAlgebra.tex` chapter**: **not a real problem.** All five
  declarations live coherently in RigidityKbar.tex § "Chart-algebra piece (ii) first-class
  decomposition" with full `\uses` wiring. A dedicated chapter would be organizational tidying
  at most (minor), not a correctness or adequacy gap. Do not block on it.
- **Recommended chapter-side actions**:
  1. (sync) Re-run sync_leanok or have the relevant owner drop the **proof-block** `\leanok`
     at RigidityKbar.tex:2356 — it falsely marks the sorry-bearing KDM proof as closed.
  2. (plan/user) The architectural signature fix for KDM (add geometric hypothesis, e.g.
     `k` algebraically closed in `B`) should be reflected in the blueprint statement once the
     user/mathematician decides; the corrected statement then propagates to
     `df_zero_factors_through_constant_on_chart` (which already carries the needed
     `GeometricallyIrreducible`+`IsReduced` data, currently discarded by its one-line delegate).

## Severity summary
- **must-fix-this-iter**: KDM `sorry` on a blueprint-substantive theorem
  (`ChartAlgebra.lean:422`) — but the only valid corrective is the *user-escalated
  architectural signature change*, not a prover decomposition; this is correctly already in
  the STUCK/escalation lane. Bidirectionally, Lean and blueprint now **agree** that the lemma
  is false as stated, so there is **no new prose-vs-Lean divergence introduced this iter** —
  the iter-150 must-fix has been resolved by the iter-151 NOTEs.
- **major**: proof-block `\leanok` at RigidityKbar.tex:2356 falsely advertises the sorry-bearing
  KDM proof as closed (sync-managed; surface to sync/plan).
- **minor**: no dedicated ChartAlgebra chapter (organizational only; not blocking).

Overall verdict: **The Lean file and the blueprint chapter are now mutually consistent —
both correctly flag the KDM lemma as false-as-stated with matching counterexamples, the
iter-151 NOTEs adequately warn future readers/provers, and the only outstanding items are the
user-escalated architectural signature fix (already in the escalation lane) and a stale
proof-block `\leanok` for the sync phase to clear.**
