## Verdict: the formula is real, the reversal of I-0449 is wrong

You asked me to try to break the claims. (A) and (D) hold. (B) is refuted — and refuted by your own theorems. (C) finds one duplicate.

Everything below is machine-checked; scratch files under `/tmp/aud1.lean` … `/tmp/aud8.lean`, all cited ones exit 0.

### (A) `chi_eq_charts_sub_overlap` — CONFIRMED

The modular-law and rank–nullity steps are both sound. `hcob` is `finrank_quotient_add_finrank` on `𝒜(D)/B(D)`, `hBeq` transports along `comapSubtypeEquivOfLe (coboundarySub_le_overlap …)`, `hmod` is the modular law with `coboundarySub = S₀ ⊔ S₁` by definition — so `hmod`'s first summand really is the sup, not a coincidence of notation. `sectionSub_top_eq_inf` is correct and `hcov` is genuinely load-bearing (confirmed by hypothesis minimisation: dropping it breaks the proof and all three downstream users). No finiteness binder is missing: mathlib's `finrank_quotient_add_finrank` and `finrank_sup_add_finrank_inf_eq` degrade gracefully, and the three you assume are exactly what the `omega` needs. Not vacuous, not `Iff.rfl` — `chi` unfolds to `ell − h1dim`, and neither `ell = dim(S₀ ⊓ S₁)` nor `h1dim = dim 𝒜 − dim(S₀ ⊔ S₁)` is definitional. This is the strongest thing in the lane.

### (B) "I-0449 measured `chi_add`, not `hbump`" — REFUTED

`chi_add_pointDivisor_of_notMem_left` is correct. The inference drawn from it is not. Your docstring says the surviving `U₁`-step is "`≥ 0` and, under approximation on that chart, exactly `[κ(P):k]`". It cannot be `[κ(P):k]` repeatedly, because `S₁` is trapped under `𝒜`:

`S₁(D) ≤ 𝒜(D)` always (`sectionSub_antitone_open inf_le_right`), and `𝒜` is frozen along the tower `n·P` by your own `sectionSub_add_pointDivisor_of_notMem`, iterated. So in `dim S₀ + dim S₁ − dim 𝒜`, all three terms are bounded along `n·P`. Hence, from your formula alone:

```
chi_bounded_along_tower : chi k U₀ U₁ (n • pointDivisor P + E) ≤ Module.finrank k (sectionSub k U₀ E)
hbump_refuted_off_chart : (U₀ ⊔ U₁ = ⊤) → P.point ∉ U₀ → hbump → False
```

That is I-0449's conclusion, now unconditional — no `chi_add`, no exactness hypothesis anywhere. The one-chart step is `0` for all but finitely many `n`, so `bump_iff_chartStep_of_notMem_left`'s right-hand side is not "approximation on one chart", it is false for large `n`. The iff is true and non-vacuous, but its content is the opposite of advertised.

I also checked the strawman question directly: under your binders plus `chi_add`'s conclusion, the `U₁`-step is provably `0` and the bump fails (`i0449_survives`). Your formula *agrees* with `chi_add` off the overlap. `chi_add`'s exactness hypotheses are not what gives way — so the meta-claim's central premise fails. There is no reading of I-0449 that needs rescuing; it was right.

The one-step view can't see this. The tower can, in twenty lines.

### (C) I-0456's lesson applied to §4 — one duplicate

`ChartCountsDegree` is `Iff.rfl` to `hledger`, and `SectionBounds.degK_principal_eq_zero` accepts it verbatim, both directions checked. So `degK_principal_eq_zero_of_chartCounts` is the existing theorem under an alpha-renamed hypothesis. Your docstring diagnoses this honestly and ships it anyway — admitting the failure mode in prose doesn't repair it.

Worse, the same tower argument gives `chartCountsDegree_refuted : P.point ∉ U₀ → ¬ ChartCountsDegree k U₀ U₁`. So §4 is vacuous on exactly the covers §1–§3 are about, and "checkable on an explicit cover" is wrong — it's unsatisfiable there.

`exists_bound_h1dim_eq_zero_of_charts` has a one-line converse (it's an iff-transport). Fine as a wrapper, not a reduction. `charts_sub_overlap_le_ell` and `h1dim_eq_zero_iff_charts` are genuine.

### (D) `sectionSub_add_pointDivisor_of_notMem` — CONFIRMED

Correct generalisation; the `U₀ ⊓ U₁` special case follows by instantiation (checked). Nothing was special about the overlap — the proof only ever used `P.point ∉ U`.

### Docstring defects

Four declarations the header advertises don't exist: `chi_add_of_charts`, `chi_add_eq_residueDeg_of_charts`, `chi_add_of_notMem_overlap`, `not_bump_of_notMem_overlap_unconditional`. The header's headline bullet names the fourth and asserts hbump is unconditionally *false* off the overlap — which is what I just proved, and the direct contradiction of what §2's docstrings argue. The header and the body disagree with each other; the header happens to be the correct one.

The provenance claim checks out: the sibling's `SumIntersection.lean` uses the same mathlib lemma for a different statement (`H⁰(C₁)+H⁰(C₂) = H⁰(C₁⊔C₂)` under four vanishing hypotheses), not this identity.

### The thing to notice about your binders

`Module.Finite k (sectionSub k U D)` at a non-total `U` is not bookkeeping. For `P.point ∉ U` it forces `ell (n·P + E)` bounded in `n` (`ell_bounded_of_chart_finite`, checked) — it forbids Riemann growth. Assuming it "for convenience" silently chose the geometry, and it is the hinge of both refutations above.

Filed `I-0467` (issue) and `I-0468` (memory). The correct move from here is I-0449's first option: restate `hbump` with an overlap-support hypothesis, or drop the chart-finiteness binders, or abandon the two-chart cover. The docstring edits made across `LedgerClosure.lean` (29-39, 383, 511-533), `SectionBounds.lean` (331, 355), `BoundedVanishing.lean:32` and `ResidueField.lean` (489-492) on the strength of the reversal need reverting.
