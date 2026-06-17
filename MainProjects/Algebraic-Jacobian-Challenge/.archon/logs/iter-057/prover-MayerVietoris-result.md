# AlgebraicJacobian/Cohomology/MayerVietoris.lean — Iter-057 prover round

## Summary

Iter-057 task: append two thin foundational n-ary basic-open intersection
helper declarations inside `namespace AlgebraicGeometry.Scheme`
`section CoverTotality`, after iter-056's `basicOpenCover_inter_isAffineOpen`,
before `end CoverTotality`. **RESOLVED on first edit** — single-Edit append
of the verbatim probe-confirmed bodies from PROGRESS.md.

## basicOpenCover_finset_inf'_eq_basicOpen_prod (newly added, L1483)

### Attempt 1
- **Approach:** Verbatim probe-confirmed body from PROGRESS.md — `classical`
  opener + `Finset.cons_induction`. The empty case is impossible by
  `t.Nonempty` (closed via `absurd h Finset.not_nonempty_empty`); the cons
  case splits on `t.eq_empty_or_nonempty`. Empty residual closed via
  `simp [basicOpenCover]`. Non-empty residual decomposes via
  `Finset.inf'_cons hne`, `Finset.prod_cons`, applies the IH, then
  `change C.left.basicOpen (a.1 : Γ(C.left, U)) ⊓ _ = _` followed by
  `rw [← Scheme.basicOpen_mul]`.
- **Result:** RESOLVED.
- **Diagnostics:** `lean_diagnostic_messages` returns
  `{success: true, items: [], failed_dependencies: []}` for the whole file.
- **Axiom check:** `lean_verify` returns
  `[propext, Classical.choice, Quot.sound]` — kernel-only.
- **Key insight:** `change` step normalises `basicOpenCover s a` (which Lean
  displays as `(fun f ↦ C.left.basicOpen ↑f) a`) to the canonical
  `C.left.basicOpen a.1` form so the subsequent `rw [← Scheme.basicOpen_mul]`
  can apply.

## basicOpenCover_finset_inf'_isAffineOpen (newly added, L1525)

### Attempt 1
- **Approach:** Verbatim probe-confirmed body — term-mode `▸` (Eq.mpr)
  rewrite chaining `basicOpenCover_finset_inf'_eq_basicOpen_prod s t h`
  with `hU.basicOpen _`. The body is one term:
  `basicOpenCover_finset_inf'_eq_basicOpen_prod s t h ▸ hU.basicOpen _`.
- **Result:** RESOLVED.
- **Diagnostics:** `lean_diagnostic_messages` returns clean.
- **Axiom check:** `lean_verify` returns
  `[propext, Classical.choice, Quot.sound]` — kernel-only.
- **Key insight:** Term-mode `▸` rather than tactic-mode `rw` is mandatory
  because the implicit `Subtype.val` coercions on elements of `Finset s`
  cause motive-occurrence issues for the rewriter. Plan-agent flagged this
  in PROGRESS.md "Known dead ends".

## Verification

- **File LOC:** 1477 → 1548 (+71). Slightly above the +30-50 estimate band
  in PROGRESS.md but within the +60-90 estimate range mentioned in the
  iteration overview; the extra LOC is from the long verbatim docstrings
  from PROGRESS.md. Function bodies are 8 + 1 = 9 LOC of actual proof.
- **Sorry count:** 9 → 9 (unchanged). 5 in `Jacobian.lean`, 3 in
  `AbelJacobi.lean`, 1 in `Picard/Functor.lean`. Zero sorries in
  `MayerVietoris.lean` (matches iter-056 closure).
- **No new axioms:** Both new declarations verified kernel-only via
  `lean_verify`.
- **Diagnostics:** clean — `{success: true, items: [], failed_dependencies: []}`.
- **Placement correct:** Both declarations land inside
  `namespace AlgebraicGeometry.Scheme` `section CoverTotality`, after
  iter-056's `basicOpenCover_inter_isAffineOpen` (now L1465-1473),
  before `end CoverTotality` (now L1546). Names dropped the `Scheme.`
  prefix as required by the namespace block (matching
  iter-035-037/049-056 pattern).
- **No new imports added:** All required names already in scope per
  PROGRESS.md probe.

## Blueprint markers ready

The review agent should add `\leanok` to the following blueprint
environments in
`blueprint/src/chapters/Cohomology_MayerVietoris.tex`
§ *N-ary basic-open intersection helpers (iter-057)*:

- `thm:Scheme_basicOpenCover_finset_inf_eq_basicOpen_prod`
- `thm:Scheme_basicOpenCover_finset_inf_isAffineOpen`

Both declarations are formalized with complete proofs (no `sorry`),
kernel-only axioms.

## Result

**RESOLVED — both iter-057 declarations closed on a single Edit using the
verbatim probe-confirmed bodies from PROGRESS.md. Eleventh consecutive
zero-corrective single-Edit iteration.**
