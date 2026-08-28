## 1. ANSWER

**WITNESS EXISTS.** Confidence **high** (≈0.9 on the mathematics; the only soft spot is the standard-but-unformalised fact that `Sym^g C = Div^g_{C/k}` carries a universal divisor finite flat of degree `g`).

One sentence: *for every `C` of genus `g ≥ 2` and every finite `π`, take `T = Div^g_{C/k} = Sym^g C` with its universal divisor `D_univ` — `D_univ` is irreducible over any `k`, and it has a fibre `ξ_s = (g−1)Q₀ + Q₁` with `Q₀` over `p₀` and `Q₁` over `p₁`, so on any affine open `Spec R ∋ s` the support is irreducible and straddles both pinned fibres, and every Zariski cover of `Spec R` has a member containing `s`.*

But the decisive correction is elsewhere: **the criterion in the prompt ("stays so after every nonempty base shrink") is the wrong criterion, and under it even the landed genus-0 example fails.** `IsLocallyCertified` (`Picard/DivisorFamilyZar.lean:71`) asks for a **span-⊤ family**, i.e. a *cover*. A cover cannot delete a point. So the correct criterion is:

> (★) ∃ `s ∈ Spec R` such that for **every** open `U ∋ s`, some connected component of `supp(D|_U)` meets both `π⁻¹(p₀)` and `π⁻¹(p₁)`.

Under the prompt's criterion, `F = tX²+XY+tY²` is evaded: its two witness points are `([1:0],0)` and `([0:1],0)`, both over `t = 0`; over `t ≠ 0` the roots are `(−1±√(1−4t²))/2t`, never `0` or `∞`, so `D|_{𝔸¹∖0}` misses *both* pinned fibres. It is a genuine counterexample only because `t = 0` must be covered. So the campaign's conclusion was right and its stated reason ("irreducible after every shrink") was only half of it.

## 2. THE MATHEMATICS

**Reduction (general, no hypotheses).** Let `S = supp D ⊆ C ×_k Spec R`; `S → Spec R` is finite (D finite flat of degree `n`), hence closed. For `c ∈ P¹(k)` put `W_c = image in Spec R of S ∩ (π⁻¹(c) × Spec R)` — closed. Then for `s ∈ Spec R`:

* `s ∉ W_c` ⟹ `U = Spec R ∖ W_c` is a neighbourhood of `s` with `supp(D|_U) ∩ π⁻¹(c) = ∅` (confined);
* `s ∈ W_c` ⟹ *every* `U ∋ s` has `supp(D|_U)` meeting `π⁻¹(c)`.

And `s ∈ W_c ⟺ supp(D_s)` meets `π⁻¹(c)`, which is a **purely fibrewise** condition. Since `D_s` is finite of degree `n` over `κ(s)`, its image in `|P¹_k|` has **at most `n` closed points**. Two corollaries:

* **(A) Necessity.** A witness needs a single `s` whose fibre `ξ_s` meets *both* `π⁻¹(p₀)` and `π⁻¹(p₁)` — needs `n ≥ 2`, i.e. `g ≥ 2`. (At `g = 1`, `W_{p₀} ∩ W_{p₁} = ∅` and `{Spec R∖W_{p₀}, Spec R∖W_{p₁}}` is a confining cover: exactly I‑0356's verdict, now with a proof.)
* **(B) Connectedness is the second half.** The two witness points must lie in the same connected component of `supp(D|_U)` for all `U ∋ s` — equivalently in the same connected component of `S ×_R O_{R,s}` (idempotents of a finite algebra descend to a finite level). Reducible constructions fail here: if `S = Δ ∪ ({b}×T)` the certifier shrinks until the components separate.

**The witness.** Hypotheses: `k` an **arbitrary** field; `C/k` smooth proper geometrically irreducible of genus `g ≥ 2`; `π : C → P¹` any finite dominant map; `p₀ ≠ p₁ ∈ P¹(k)` the two pinned points.

1. `Div^g_{C/k} ≅ Sym^g C =: T` exists over `k`: smooth projective, geometrically irreducible, dimension `g`, with universal `D_univ ⊆ C ×_k T` a relative effective Cartier divisor, **finite flat of degree `g`** over `T` (Kleiman, *The Picard scheme*, FGA Explained §9.3; BLR §8.2/9.3). Every degree-`g` relative divisor over every `R` is a pullback of `D_univ` — so this analysis is exhaustive, not just an example.
2. **`supp D_univ` is irreducible over any `k`**: it is the image of the finite surjection `C × Sym^{g−1}C → C × Sym^g C, (x,ξ) ↦ (x, x+ξ)`, and `C × Sym^{g−1}C` is irreducible because `C` is geometrically irreducible. *No monodromy argument, no `k = k̄`.*
3. **The straddling point.** `π` finite dominant ⟹ `π⁻¹(p₀), π⁻¹(p₁) ≠ ∅`. Pick closed points `q₀, q₁` in them and a finite extension `L/k` admitting `k`-embeddings of both `κ(q₀), κ(q₁)` (take a residue field of `κ(q₀) ⊗_k κ(q₁)`). Get `Q₀, Q₁ ∈ C(L)` over `p₀, p₁`. Since `g ≥ 2`, `ξ = (g−1)Q₀ + Q₁` is an effective divisor on `C_L` of degree exactly `g`, i.e. an `L`-point of `T`; let `s ∈ T` be the underlying closed point (`κ(s) ⊆ L`). **No rational-point hypothesis is used**: padding is by multiples of `Q₀`, so no "effective divisor of degree m exists" problem arises.
4. `T` is quasi-projective, so choose an affine open `Spec R ⊆ T` with `s ∈ Spec R`, and set `D = D_univ|_{Spec R}` — a relative effective Cartier divisor of degree `g = n`, finite flat over `R`. On-stratum.
5. **Non-confinability.** Let `{D(g_i)}` be any span-⊤ family. Some `D(g_i) ∋ s`. Then `supp(D|_{D(g_i)}) = supp(D_univ) ∩ (C × D(g_i))` is a nonempty open of the irreducible `supp D_univ`, hence **irreducible, hence preconnected**; and it contains points over `p₀` and over `p₁` (images of `Q₀, Q₁`, lying over `s ∈ D(g_i)`). By `not_isCertified_of_isPreconnected_of_witnesses` (`DivSchemeCertZarVerdict.lean:62`), no `CertifiedDivisorFamily` exists over `Localization.Away (g i)` `DivEq`-equal to the pullback (`supportLocus_pullback`, `DivEq.supportLocus_eq`). So `D ∉ DivFamZar(R)` while `D ∈ Div^g_{C/k}(R)`. ∎

## 3. FIELD DEPENDENCE

Works over **every** field: `F₂`, non-perfect, imperfect, non-algebraically-closed, infinite. The three places a field hypothesis could enter are all discharged: irreducibility of `Sym^{g−1}C` is geometric irreducibility of `C` (standing); the straddling divisor uses an `L`-point, not a `k`-point; and step 5 needs no separability. Enlarging `k` does not escape it, and descent from a large field (leaf `dat-g`) does not either — the witness is already there over the small field.

## 4. π DEPENDENCE

**No choice of `π` helps, and no choice of the pinned pair helps.** The construction uses `π` only through `π⁻¹(p₀) ≠ ∅ ≠ π⁻¹(p₁)`, automatic for finite dominant `π`. Sharper, from the reduction in §2 (this is the decision-relevant result):

> **R1 works if and only if `|P¹(k)| ≥ n + 2`.**
> *If:* for any `D`, `R`, `s`, the image of `supp(D_s)` in `P¹` has ≤ `n` closed points; pick `c ∈ P¹(k)` outside it and any `c' ≠ c`; then `U = Spec R ∖ W_c` confines `D|_U` to the chart complementary to `π⁻¹(c)`. Zariski-locally, with the pair varying per member — which is exactly what R1 allows.
> *Only if:* if `Σ_{c ∈ P¹(k)} e_c ≤ g` where `e_c` = minimal degree of a closed point of `C` over `c` (e.g. `q+1 ≤ g` with `C` having a rational point over each `c`), take `ξ_s = Σ_c q_c + padding`; then `s ∈ W_c` for every `c ∈ P¹(k)` and no pinned pair confines.

So `p1-aut`/R1 is **not** dead in general — it is alive over infinite `k` and over `F_q` with `q ≥ g+1`, and dead over small finite fields. This **settles I‑0346's bound as exactly sharp**, in both directions; it was previously only a sufficient guess. R2 (arbitrary affine opens as pieces) remains the only field-uniform fix: `supp D` is finite over `R`, hence contained in a single affine open of `C × Spec R` by the avoidance lemma for families (Stacks 0B8B), so a one-straddling-piece cover always exists.

## 5. LEAN COST — do **not** formalise

Formalising the witness needs `Sym^g C`/`Hilb^g` with its universal flat divisor. Mathlib has no Hilbert schemes, no symmetric products of schemes, no Picard scheme; the tree constructs no curve other than `P1`. This is a multi-year dependency, and the payoff is a *negative* statement that changes no theorem. A concrete genus-2 hyperelliptic witness is not cheaper — it still requires building a non-rational proper curve as a scheme, which the tree has never done (`C` is always a variable with hypotheses).

Honest move — record, don't formalise:

* `informal/spec-dd-r.md` — a new **ADDENDUM 4** carrying §2–§4 verbatim, and a **third corrigendum** to ADDENDUM 3 fixing the shrink-stability argument (the correct reason is "a cover must contain `s`", not "shrinking keeps the generic point"). Closes I‑0356.
* `roadmap.md:68–71` — replace "one open question over small finite fields" with the **iff**: R1/`p1-aut` is correct exactly when `|P¹(k)| ≥ g+2`; keep it only if the campaign accepts that hypothesis, otherwise commit to R2. Leaf `…certificate.field-size` can be closed as *answered*, not blocked.
* `AlgebraicJacobian/Picard/DivSchemeCertZarConn.lean:170–175` — the docstring's model is genus 0; annotate it as off-stratum and cite the addendum.
* Optional, ~40 lines, worth it: strengthen `DivSchemeCertZarC1.lean:131` / `Verdict.lean:62` from `IsPreconnected d.supportLocus` to the per-connected-component form (the clopen-trace proof at `Conn.lean:98` already gives it). That is the honest statement of the no-go and it is what the general witness analysis in §2 needs.

## 6. WHAT THE LEAD GOT WRONG

* **The shrink criterion.** "Removing finitely many points keeps the generic point, hence keeps connectedness" is true but irrelevant, and it does *not* give shrink-stability: it forgets that the straddle is destroyed by removing the one base point `[P₀+P_∞]`. The real reason the witness survives is that a **cover** must contain that point. Under the prompt's literal criterion the answer would be **NO WITNESS** — including for the campaign's own landed genus-0 example.
* **`Sym²` and the auxiliary curve `T` are unnecessary.** No `T ⊂ Sym^g C` is needed: take an affine open of `Sym^g C` itself. Then "the generic member is not a sum of two rational points" is automatic and needs no monodromy argument — irreducibility of `D_univ` is the image of an irreducible product. (For a curve `T`, the lead's condition is the right one, but it is a condition on `D_T`, not on the preimage in `C × C` per se.)
* **Rational points.** The lead needs `P₀, P_∞ ∈ C(k)`, which fails over `F₂` and for `g = 2` with both fibres single degree-2 points. The fix is to take `s` a **non-rational closed point** of `Sym^g C` given by an `L`-point; the functor's witness point `s` never had to be `k`-rational.
* **`D_T` Cartier/flat.** Yes, but it comes free from `Div^g = Hilb^g`, not from any argument about `T`.
* **"Does the answer depend on `π`"** — the lead did not anticipate that the same reduction gives an *iff* for R1 in terms of `|P¹(k)|`, which is the actually decision-relevant output of this investigation.
