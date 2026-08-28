## Verdict

**Mathematically sound, strategically over-claimed, and still not converging on a deliverable.** Every theorem in the two audited commits is correct, sorry-free and kernel-checked; the session's diagnosis is genuinely valuable. But the headline claims written into the roadmap (REJECT `tube-fibre`/`leak-image`, BLOCK/low `away-kerspan`, urgent `chart-avoid`) are each one unproved lemma or one hypothesis stronger than what the Lean actually says. And after 5 commits / ~900 new lines, **zero** declarations in the `DivSchemeCertZar*` tower are referenced by anything outside it — the island flagged in I-0328 is now larger, not smaller.

## Your four claims

**C1 — TRUE, both inclusions genuine.** `⊆` is `FinCoverData.cover₀`, which is `le_iSup_basicOpen_of_sum_eq_one` applied to `partition₀ : ∑ a₀ j * h₀ j = 1` in `Γ(relCurve, V₀)` — a real partition of unity on the whole chart, not a sub-open. `⊇` is `Scheme.basicOpen_le`, correct since `h₀ j` is a section *over* `V₀`. Your (b): `m₀ = 0` forces `0 = 1` in `Γ(V₀)`, i.e. `V₀ = ∅` — no escape.

**C2 — TRUE and faithful.** `supportLeak_eq_empty_of_forall_fibre` (`SupportTubeFinite.lean:124`) takes literally the assembler's `hnoLeak j` shape and needs nothing else; `hnoLeak` is *definitionally* trace-closedness, the fibre quantifier is decoration. Hypothesis shapes at `DivSchemeCertUniv.lean:104` and `DivSchemeCertZarKerSpan.lean:123` match character for character.

**C3 — counter-model sound; the conclusion is stronger than what you proved.** The model is right: `tx²+xy+ty²` is irreducible over `k[t]` (disc `1−4t²` is not a square in `k(t)`), so `V(F)` is integral, hence connected over every base localization — no idempotent, ever. Fibre at `t=0` is `{0,∞}`. And the failure is honest, not definitional: the chart colength is `k[t][u]/(tu²+u+t)`, which is **not** finite over `k[t]` because `u` has minimal polynomial `u² + u/t + 1` and `k[t]` is integrally closed. Base localization can't evade it since `IsLocallyCertified` requires `Ideal.span (Set.range g) = ⊤`, and `DivEq` re-spelling can't (support is a germ-unit locus, invariant under unit rescaling — though **no in-project lemma states `DivEq d d' → supportLocus d = supportLocus d'`**). Two over-claims:
- The necessary condition proved is *chart traces closed*, not `supportLocus ⊆ V₀ ⊓ V₁`. The latter is only the sufficient side used by `Swallow`/`ChartPair`.
- The `Conn` verdict needs **`IsPreconnected supportLocus`**. A degree-`n` relative divisor is typically *disconnected*. `σ₀ ⊆ V₀\V₁` plus `σ₁ ⊆ V₁\V₀` gives both traces closed while the divisor lies in neither chart and meets both fibres. So "the interface only sees chart-confined divisors" is false in general; the honest condition is componentwise. (I-0339)

**C4 — WRONG as stated; say it loudly.** Verified in Lean: `A.toOvlLeft i i = A.toOvlRight i i` holds **by `rfl`** (proof irrelevance makes `inf_le_left`/`inf_le_right` the same proof at `pieces i ⊓ pieces i`). So every diagonal component of `deltaLeft - deltaRight` is identically zero, for every adaptation, and `coker δ` always retains `∏_i ovlColength i i ≅ ∏_i colength i` as a direct factor. Therefore **(c4) ⟹ `Module.Flat R (A.colength i)` for all `i`**, and via the syzygy equivalence so does `hinj`. (c4) can never be "free". Also: (c2) still carries `rankAtStalk_glued = n`, which under swallow-or-miss is exactly the degree input `hdeg`; the off-diagonal image is the anti-diagonal `{(c,−c)}`, not the whole block (your roadmap body's "leftover copy" is right, the word "surjective" is not); and "≤1 swallowing piece per chart" is *not* forced by `FinCoverData` — it holds only by construction in `swallow-adapt`. The correct claim is **"(c2)/(c3)/(c4) reduce to (c1)-projectivity + degree"**, which is a real reduction but not a retirement of `away-kerspan`. Your one technical lemma (unit mod `(g)` when `V(g) ∩ V(h) = ∅`) is correctly identified and is genuinely load-bearing. (I-0340)

## Other findings

- **The keystone is missing** — `IsCertified` does not contain no-leak. `Conn.lean:125`'s "(c1) forces leak-freeness" is asserted, never proved; grep finds only the three sufficient directions. Ground filed this as I-0334; I archived my duplicate and added the proof sketch (finite ⟹ proper ⟹ closed image, using separatedness of `relCurve/R`). Until it lands, the `tube-fibre`/`leak-image` rejections and the `away-kerspan` demotion are conditional.
- **Ledger index is dirty**: `DivSchemeCertZarChartPair.lean` is staged as a *deletion* while HEAD contains it and `AlgebraicJacobian.lean:330` imports it. Content is safe (blob matches HEAD), but the next plain `add`+`commit` can delete it and break the default build. Re-seed with `read-tree HEAD`. (I-0341)
- **No breakage otherwise.** Both audited commits touch only their own file plus one import line. Import chain `Leak → {ChartTrace, Transport} → Swallow → Conn → ChartPair` is acyclic and all five oleans exist. No sorries, no axioms.
- **The dangling `ChartPair` reference resolved itself** (commit `03ea445d9`, 25 min later); `ofChartPair` honestly takes chart-principality as explicit data, and its (c1) result needs `supportLocus ⊆ V₀ ⊓ V₁` — which is the *sufficient*, not the necessary, condition, so `ChartPair` subsumes `Swallow` for the useful case.

## Throughput

Real but thin. `ChartTrace` is a finite-union-of-closed-sets step on top of last session's iff; `Swallow`'s main theorems are corollaries of an existing iff (the dichotomies are the new part); `Conn` is the session's genuine new mathematics and it is correct. Set against it: the lane's last four productive sessions have produced necessity results, no-gos and roadmap re-framings, and still no producer of a `DivFamZar`/`IsLocallyCertified` value. I-0328's recommendation ("land one composition end-to-end, even conditionally on `hnoLeak`") remains unactioned; `Transport` is the one step toward it.

## Files

- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivSchemeCertZarChartTrace.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivSchemeCertZarSwallow.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivSchemeCertZarConn.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivSchemeCertZarChartPair.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamily.lean` (`ovlProd`/`deltaLeft`/`deltaRight`, lines 330-441)

Inbox filed: **I-0339** (connectedness over-scope), **I-0340** (cert-collapse not free), **I-0341** (staged deletion), **I-0342** (memory: diagonal blocks), comment on **I-0334**; **I-0338** archived as a duplicate of I-0334.
