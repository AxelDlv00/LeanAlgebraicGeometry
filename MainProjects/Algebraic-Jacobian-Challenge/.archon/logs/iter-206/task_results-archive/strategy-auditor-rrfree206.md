# Strategy Audit Report: RR-Free Representability of Pic⁰ (Iter 206)

**Slug:** rrfree206  
**Date:** 2026-05-29  
**Sources read:** Kleiman `kleiman-picard-src/kleiman-picard.tex` (full §4, §5, §6); Nitsure `nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` (§5 in full); Milne `abelian-varieties.pdf` (Chapter III §1–§6, pp. 85–110).

---

## Sub-question 1: RR-free bare representability

**Verdict: VALIDATED**

### Finding

The FGA/Grothendieck–Nitsure construction of `Pic_{X/S}` representability invokes **zero** Riemann–Roch at any point. This is confirmed in both sources:

**Nitsure (§5, Construction of Quot Schemes, pp. 23–28):** A full-text grep for "Riemann" in `nitsure-hilbert-quot.tex` returns **no matches**. The construction uses: Castelnuovo–Mumford regularity (§2), base-change for flat sheaves (§3), flattening stratification (§4), embedding of Quot into a Grassmannian via `m`-regular global sections, and the valuative criterion for properness. Nothing close to RR appears.

**Kleiman §4 (`th:main`, L2155–2417):** RR appears in Kleiman's paper only in (a) the historical introduction (equation `\ref{equation:RR}`, L517, the classical Abel–Roch formula) and (b) Appendix B (`prp:RR`, L6134, "Riemann–Roch for surfaces" in the intersection-theory appendix). Neither appears in §4. The proof of `th:main` decomposes `P = Pic_{(X/S)_et}` into open–closed pieces by Hilbert polynomial:

> *"Given a polynomial φ ∈ ℚ[n], let P^φ ⊂ P be the étale subsheaf associated to the presheaf whose T-points are represented by the invertible sheaves ℒ on X_T such that* χ(X_t, ℒ^{-1}_t(n)) = φ(n) *for all t ∈ T."* (L2188–2192)

This is χ-based, not degree-based; no Hilbert–polynomial = degree-formula is invoked. The proof then uses vanishing-of-higher-direct-images conditions (`eq:4b`/`eq:4c`), the Hilbert scheme representability of `Div_{X/S}`, the linear series `IP(Q)`, the surjectivity of `Z → P₀^{φ₀}` via étale sections (using EGAIV4 17.16.3), and the patching lemma `lm:qt`. No step invokes RR.

**Conclusion:** Bare representability of `Pic_{X/S}` is classically RR-free. RR enters the Picard-scheme story only later: to compute dimensions (`thm:tgtsp` gives `T_0 Pic = H^1(O_X)` — also RR-free), to identify components by degree, or to prove properties of the Sym^d–Abel route.

---

## Sub-question 2: Degree-0 component without RR

**Verdict: VALIDATED (with one caveat about the equivalence proof)**

### Finding A — defining `Pic⁰ := Pic^z` is RR-free

Kleiman §5 ("The connected component of the identity," L2836–4041) defines `Pic^z_{X/S}` as the connected component of the identity element and proves:

> *"It is remarkable how much we can prove about* `IPicz_{X/S}` *formally, or nearly so, from general principles. Notably, we can do without the finiteness theorems proved in the next section."* (L2843–2845)

Key results, all RR-free:
- **`prp:pic0`** (L2921–2933): For `S = Spec k`, if `Pic_{X/k}` exists, then `Pic^z_{X/k}` is an open-and-closed group subscheme of finite type, geometrically irreducible, and stable under field extension. Proof cites only `lem:agps` (general group scheme theory).
- **`th:qpp&p`** (L2935–2984): If X/k is projective and geometrically integral, then `Pic^z_{X/k}` exists and is quasi-projective. If also geometrically normal, it is projective. Proof: quasi-projectivity from `ex:q-proj`; projectivity from the Chevalley–Rosenlicht structure theorem (no RR). For smooth C/k, geometrically normal follows from smoothness.

Defining `Pic^0 := Pic^z_{X/k}` (the identity component) is therefore RR-free.

### Finding B — the equivalence `Pic^z = Pic^0_{degree}` does require RR

Kleiman **`ex:curves`** (L4661–4680) sets up `Pic^m_{X/S}` as the degree-m stratum and asks the reader to:

> *"Show there is no abuse of notation: the fiber of* `IPicz_{X/S}` *over s ∈ S is the connected component of* 0 ∈ `IPic_{X_s/k_s}`.*"*

This is a *proof obligation*, not a definition. Milne (p. 88) makes the required ingredient explicit:

> *"and the Riemann-Roch theorem says that* χ(C, ℒⁿ) = n deg(ℒ) + 1 − g. *This gives a more canonical description of deg(ℒ): when* χ(C, ℒⁿ) *is written as a polynomial in n, deg(ℒ) is the leading coefficient."*

This RR formula is what links the Hilbert-polynomial decomposition (which Kleiman §4 uses) to the degree-grading. Specifically:
- `Pic^z ⊆ Pic^0_{degree}` follows because `O_C` (degree 0) lies in the identity component, and the degree function is locally constant by this RR formula.
- `Pic^0_{degree}` is connected (= `Pic^z`) follows from the absence of torsion for integral curves (`ex:curves` also asks to show `Pic^z = Pic^τ`).

**Conclusion for sub-question 2:** The project CAN define `Pic^0 := Pic^z` (identity component) — this is fully RR-free. Kleiman §5 constructs and characterises `Pic^z` without RR. The *proof* that this equals the degree-0 stratum requires RR (via Milne p. 88), but this proof is not needed to *have* and *use* `Pic^z` as the Jacobian. The project must **not** prove or use the statement "`PicScheme.degComp C 0 = Pic^z`" in the genus ≥ 1 arm if it wants to stay RR-free — instead it should directly define `Pic^0 := Pic^z` throughout.

**Silent assumption flagged:** If the project's current Lean definition is `Pic⁰ := PicScheme.degComp C 0`, switching to `Pic^z` is a definitional change, not just a proof change. The degree-zero characterisation and the identity-component characterisation are provably equivalent (for smooth proper geom-integral curves), but that proof requires RR.

---

## Sub-question 3: Downstream RR dependence

**Verdict: PARTIAL — Milne's Sym^d route forces RR; Kleiman's Albanese route avoids it with a caveat**

### Finding A — Milne's Sym^d/Abel construction route forces RR at multiple places

**Milne III §4, Proposition 4.2(b), p. 100** (constructing a section of `Div^r_C → P^r_C`):

> *"Let ℒ be an invertible sheaf on C × T representing an element of P^γ(T). Then h⁰(ℒ_t ⊗ ℒ_γ⁻¹) = 1 for all t, **and the Riemann-Roch theorem shows that h¹(D_t − D_γ) = 0 for all t**."*

This is the key step that produces a section, making `P^r_C` representable. **Explicit RR.**

**Milne III §5, Lemma 5.2(b), p. 102** (open cover of C^{(r)} needed for Theorem 5.1):

> *"The Riemann-Roch theorem now shows that h⁰(Σ Pᵢ) = r + (1 − g) + (g − r) = 1 for all (P₁,...,P_r) in U."*

**Explicit RR.** This is used to prove the Abel map f^{(r)}: C^{(r)} → J is birational.

**Milne III §5, Theorem 5.1 proof, p. 103** (birationality of C^{(g)} → J):

> *"The Riemann-Roch theorem says precisely that these two numbers are equal, and so completes the proof."*

**Explicit RR.** The two numbers are dim Im(di)_D = |D| and dim Ker(df^{(r)})_D = g − h⁰(Ω(−D)).

**Milne III §6, Proposition 6.1, p. 104** (Albanese UP): The proof uses the rational map ψ̂: J → A obtained by factoring (P₁,...,P_g) ↦ Σ ψ(Pᵢ) through C^{(g)}, then invoking (I 3.2) to extend. The factoring through J uses the birational map f^{(g)}: C^{(g)} → J (Theorem 5.1), which relies on RR as above. **Indirect RR.**

**Milne III §1, p. 87** (surjectivity of Abel map, used as prerequisite):

> *"For a divisor of degree r, the Riemann-Roch theorem says that ℓ(D) = r + 1 − g + ℓ(K − D) ... every divisor class of degree r contains an effective divisor, and so the map φ: {effective divisors of degree r} → Pic^r(C), D ↦ [D] is surjective when r > 2g − 2."*

**Explicit RR.** This surjectivity (for d ≥ 2g−1) is what makes the Sym^d/Abel route work. The threshold d ≥ 2g−1 is precisely RR-controlled.

### Finding B — Kleiman's Albanese route (`rmk:Alb`) is RR-free for the universal property itself

Kleiman `rmk:Alb` (L3960–3988) gives a self-contained Albanese universal property for `Pic^z(X)` using only the Comparison Theorem and the group-scheme structure of `Pic^z`:

> *"Consider a map a: B^* → P such that a(0) = 0. By the Comparison Theorem, Theorem th:cmp, a corresponds to an invertible sheaf ℒ on X × B^* such that ξ^*ℒ ≅ O_X. ... Then ℒ defines a map b: X → B such that b(x) = 0. Reversing the preceding argument, we see that every such b arises from a unique map a: B^* → Pic_{X/k} such that a(0) = 0. ... In particular, 1_P corresponds to a natural map u: X → A such that u(x) = 0, and every map b: X → B factors uniquely through u."*

This proof uses:
- `th:cmp` (Comparison Theorem, L1384–1399): RR-free; it equates the four Picard functors under the hypothesis O_S ≅ f_*O_X.
- `th:qpp&p` (projectivity of `Pic^z`, RR-free).
- The duality between `B` and `B^* = Pic^z(B)` for an abelian variety B (from `rmk:Ablsch`).

The Albanese variety in Kleiman's route is A = `Pic^z(Pic^z(C)) = J^∨` (the dual Jacobian), and the universal Albanese map is u: C → J^∨. **This step is RR-free.**

### Caveat: autoduality J ≅ J^∨ may force RR

To identify `J^∨` (Kleiman's Albanese output) with `J = Pic^z(C)` (the Jacobian), one needs autoduality. Kleiman `rmk:Jac` (L3990–4016) cites [EGK, Thm 2.1] for the autoduality isomorphism A_L^*: Ĵ ≅ J. The degree-1 invertible sheaf ℒ required for the Abel map A_L requires either C(k) ≠ ∅ or an fppf cover. The [EGK] autoduality proof (Esteves–Gagné–Kleiman) is for a compactified Jacobian and is independent of RR at the level of the abstract statement, though the classical proof (via degree of the polarization = 1 using θ-divisor) typically invokes RR for abelian varieties.

**If the project's goal is stated as "J^∨ is the Albanese variety of C" (rather than "J = Albanese(C)"), the Kleiman `rmk:Alb` route is fully RR-free.** If full self-duality J ≅ J^∨ is needed, this is a separate task that may require additional machinery beyond Route C.

---

## Bottom Line

### Can RR be cut from the genus ≥ 1 critical path for representability + Pic⁰-identification?

**YES, for the representability and Pic⁰-definition layer:**
- `Pic_{X/S}` representability (Kleiman §4 / Nitsure §5): **fully RR-free.**
- `Pic^z_{X/S}` = identity component: **fully RR-free** (Kleiman §5).
- Both `Pic_{X/S}` and `Pic^z_{X/S}` are projective abelian schemes for smooth proper geom-integral C/k: **fully RR-free.**
- The Abel map f^P: C → J (defined via divisorial correspondences, Kleiman `rmk:Jac`): **RR-free** given a degree-1 invertible sheaf (equivalently, a rational point P ∈ C(k)).

**PARTIAL, for the downstream Albanese UP:**
- **Milne's Sym^d route** (currently in the project via Route C) forces RR at Prop 4.2(b), Lemma 5.2(b), Theorem 5.1, and indirectly at Prop 6.1.
- **Kleiman's `rmk:Alb` route** gives an RR-free Albanese universal property with output A = J^∨. Identifying J ≅ J^∨ (autoduality) is a further step that may or may not need RR depending on the proof path.

### Which downstream nodes still force RR

| Node | RR forced? | Source |
|------|-----------|--------|
| Bare representability of `Pic_{X/S}` | **No** | Kleiman §4, Nitsure §5 |
| `Pic^z` = connected component of identity | **No** | Kleiman §5 |
| Projectivity of `Pic^z` (genus g curve → abelian variety) | **No** | Kleiman `th:qpp&p` |
| Abel map f^P: C → J | **No** (needs rational point) | Kleiman `rmk:Jac` |
| Sym^d surjectivity (`C^{(r)} → Pic^r` for r > 2g−2) | **Yes** | Milne III §1 p.87 |
| Section construction for `Div^r_C → P^r_C` | **Yes** | Milne III §4 Prop 4.2(b) |
| Birationality of C^{(g)} → J | **Yes** | Milne III §5 Thm 5.1 |
| Albanese UP via Sym^d (Milne Prop 6.1) | **Yes (indirect)** | Milne III §6 Prop 6.1 |
| Albanese UP via Comparison Thm (Kleiman `rmk:Alb`) | **No** (output = J^∨) | Kleiman §5 `rmk:Alb` |
| Autoduality J ≅ J^∨ (to recover J as Albanese) | **Likely yes** | Kleiman `rmk:Jac` / [EGK] |
| Genus formula dim J = g | **Yes** | Milne III Prop 2.1; uses RR (H^1(O_C)≅T_0J) |

### Silent assumptions the re-route must not violate

1. **Projectivity, not merely properness.** Kleiman `th:main` and `th:qpp&p` require X/S *projective* (Zariski locally). A smooth proper curve over a field is projective, so this is satisfied, but must be stated.

2. **Geometric normality for projectivity of `Pic^z`.** Kleiman `th:qpp&p` requires X/k *geometrically normal* for `Pic^z` to be projective (not just quasi-projective). Smoothness implies normality, but this hypothesis must be tracked.

3. **k-rational point requirement.** Kleiman's `rmk:Alb` requires a base point x ∈ X(k). Milne Prop 6.1 requires P ∈ C(k). Milne's Proposition 1.14 handles the case C(k) = ∅ by a Galois descent argument (no RR involved). The project must flag whether C is assumed to have a rational point.

4. **Sym^d surjectivity threshold.** If the project uses any Sym^d argument at degree d ≥ 2g−1 to prove surjectivity, it is invoking RR (Milne III §1 p.87). This threshold is hard-wired into Milne's construction. The Kleiman `rmk:Alb` alternative avoids it entirely.

5. **Definitional gap.** The project currently uses `PicScheme.degComp C 0` as Pic⁰. Switching to `Pic^z` (identity component) is a **definitional change** in Lean. It will require re-routing the definition through `lem:agps`/`prp:pic0` (identity-component construction of group schemes), not through the Hilbert-polynomial stratum. The equivalence `Pic^z = PicScheme.degComp C 0` is a theorem (requiring RR) that should be deferred, not a tautology.

---

## Recommendation

The re-route is mathematically sound at the representability + Pic⁰-definition layer:

> **Cut Route C from the critical path for `Pic_{X/S}` representability and `Pic^z` construction.** Both are RR-free per Kleiman §4–§5 and Nitsure §5.

> **Switch the Lean definition of `Pic⁰` from `PicScheme.degComp C 0` to `IPic^z_{C/k}` (identity component).** This removes the RR-dependent identification of Hilbert-polynomial strata with degree-zero bundles.

> **For the Albanese UP:** Replace Milne's Sym^d route (Prop 6.1 via Thm 5.1) with Kleiman's `rmk:Alb` route, which gives A = J^∨ as the Albanese object. The claim that J = J^∨ (self-duality) is the one remaining node that likely requires either RR or a separate investment in the autoduality theory (cite [EGK] / Mumford §20, or defer).

> **For the genus formula** dim J = g: this requires RR (or Milne Prop 2.1 which uses the identification T_0(J) = H^1(O_C)); defer to Route C or accept as a sorried lemma until RR is available.
