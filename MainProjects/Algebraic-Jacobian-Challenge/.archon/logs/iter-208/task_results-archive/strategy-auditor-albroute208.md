# Strategy-Auditor Report — iter-208
## Albanese UP Route Choice: `rmk:Alb` (Route 2) vs. Milne Thm 3.2 (Route 1)

**Verdict summary:** Route (2) via Kleiman `rmk:Alb` is real and delivers the UP from representability — but it lands on **J^∨**, not J. The autoduality bridge J^∨ ≅ J does **not** require Riemann–Roch; it requires theta-divisor / Poincaré sheaf machinery. The Stacks-02JK / conormal-iso approach in the Route (1) cone is an **over-decomposition**: Milne's actual codim-≥2 proof uses only the valuative criterion of properness, with no conormal sequence. The 27-iter stuck node is not solving the right sub-problem.

---

## Audit Question 1 — Does Kleiman derive the Albanese UP from representability, and on J or J^∨?

**Yes — on J^∨, not J.** The project's belief is exactly correct.

### Kleiman `rmk:Alb` — verbatim structure (source lines 3960–3988)

```latex
\begin{rmk}\label{rmk:Alb}
Assume $S$ is the spectrum of an algebraically closed field $k$, and $X$
is normal, integral, and projective.  Then $\IPicz_{X/k}$ is irreducible
and projective by Proposition~\ref{prp:pic0} and Theorem~\ref{th:qpp&p}.
Set $P:=(\IPicz_{X/k})_{\red}$ and $A:=\IPicz_{P/k}$.  Then $P$ is
plainly an Abelian variety; whence, $A$ is an Abelian variety too by
Remark~\ref{rmk:Ablsch}.

Fix a point $x\in X(k)$.  Let $B$ be an Abelian variety, and set
$B^*:=\IPicz_{B/k}$.  Then $B^*$ is an Abelian variety too, and there is
a canonical isomorphism $B\risom B^{**}$ by Remark~\ref{rmk:Ablsch}.
...
Reversing the preceding argument, we see that every such $b$ arises from
a unique map $a\:B^*\to \IPic_{X/k}$ such that $a(0)=0$.  Since $B^*$ is
integral, $a$ factors through $P$.  Thus the maps $a\:B^*\to P$ and
$b\:X\to B$ are in bijective correspondence.  ...  In particular, $1_P$
corresponds to a natural map $u\:X\to A$ such that $u(x)=0$, and every
map $b\:X\to B$ factors uniquely through $u$.
\end{rmk}
```
*(Kleiman, "The Picard scheme", arXiv:math/0504020, §5, lines 3960–3988)*

**What this says:**
- `P = (Pic⁰_{X/k})_red` — for a smooth curve C, `Pic⁰_{C/k}` is already smooth by `cor:sm` (line 3421), so `P = J` exactly.
- `A = Pic⁰_{P/k} = Pic⁰_{J/k} = J^∨` — the dual abelian variety.
- The universal object is `u : X → A = J^∨`, not `u : X → J`.
- The key tool is the **Comparison Theorem** (`th:cmp`, lines 1384–1399): under the hypothesis `O_S ≅ f_* O_X` universally plus a section, `Pic_{X/S} ≅ Pic_{(X/S)ét}`. For X/k with k algebraically closed and X geometrically irreducible, these hypotheses hold.

**Autoduality J^∨ ≅ J** — where Kleiman states it: `rmk:Jac` (lines 3990–4016):

```latex
\begin{rmk}\label{rmk:Jac}
 ...  Set $J:=\IPicz_{X/S}$; ...  Set $\wh J:=\IPicz_{J/S}$; it exists, is a
projective Abelian scheme, and is ``dual'' to $J$ by Remark~\ref{rmk:Ablsch}.

Suppose $X$ has an invertible sheaf $\mc L$ whose fibers $\mc L_s$ are of
degree 1.  Define an associated ``Abel'' map $A_{\mc L}\:X\to J$ ...
Then $A_{\mc L}$ induces, via pullback, an ``auto-duality'' isomorphism
  $$A_{\mc L}^*\:\wh J\risom J.$$
This isomorphism is independent of the choice of $\mc L$; in fact, it
exists even if no $\mc L$ does.  These facts are proved in
\cite[Thm.~2.1, p.~595]{EGK}.
\end{rmk}
```
*(lines 3990–4016)*

**Cost of autoduality:** The isomorphism `Ĵ = J^∨ ≅ J` is established via Abel-map pullback. Kleiman cites [Thm 2.1, p.595]{EGK} (Esteves–Gagné–Kleiman), noting it holds even when no degree-1 sheaf exists and extends to integral curves with double points. **No Riemann–Roch is invoked.** Milne's proof of the same autoduality (Theorem 6.6, p.105) uses the theta divisor `Θ` and the Poincaré sheaf, across Lemmas 6.7–6.9 (pp.105–107):

> "THEOREM 6.6. *The map φ_{L(Θ)}: J → J^∨ is an isomorphism; therefore, 1 × φ_{L(Θ)} is an isomorphism (J × J, L'(Θ)) → (J × J^∨, P).*"

The proof cites Milne 1986 (12.13) for `φ_{L(Θ^-)} = φ_{L(Θ)}`, then deduces the isomorphism from Lemma 6.9 (f^∨ and φ_{L(Θ)} are inverse). **RR appears only as a consequence** (Exercise 6.12: "It follows from (6.6) and the Riemann-Roch theorem (I 11.1) that χ(Θ^g) = g!"), **not as a premise** of the autoduality theorem itself.

**Scope caveat:** `rmk:Alb` assumes `k` is algebraically closed. The project's goal is over a general field k. For a geometrically irreducible curve C, descent from k̄ is standard (Milne handles this in Prop 6.4's proof: "Let k' be a finite Galois extension of k, and suppose that there exists a unique homomorphism ψ: C_{k'} → J_{k'} such that ψ ∘ F_{k'} = φ_{k'}. Then uniqueness implies that σψ = ψ for all σ ∈ Gal(k'/k), so ψ is defined over k."). The autoduality from `rmk:Jac` is stated for relative abelian schemes over a Noetherian base S, not just over k̄.

---

## Audit Question 2 — Is the Milne Thm-3.2 cone necessary?

**No.** It is Milne's *proof route* to his Prop 6.1, not the only route to the universal property.

### Milne Prop 6.1 — how Thm 3.2 enters

> "PROPOSITION 6.1. *Let P be a k-rational point on C. The map f^P: C → J has the following universal property: for any map φ: C → A from C into an abelian variety sending P to 0, there is a unique homomorphism ψ: J → A such that φ = ψ ∘ f^P.*"

Milne's proof (p.104): "Consider the map (P_1,...,P_g) ↦ Σ_i ψ(P_i): C^g → A. Clearly this is symmetric, and so it factors through C^{(g)}. It therefore defines a rational map ψ̄: J → A, which **(I 3.2) shows to be a regular map.**"

So Milne's Prop 6.1 explicitly invokes Thm 3.2 (rational map to AV is regular). However, Kleiman's `rmk:Alb` achieves the same universal property through a completely different path — via the **Comparison Theorem** and representability of Pic — with no rational-map-extension step at all.

**Assessment:** The Thm-3.2 cone (Route 1) is Milne's proof route, not an intrinsic logical prerequisite of the UP. Kleiman's `rmk:Alb` is an independent derivation. If the project pursues Route (2), the Thm-3.2 cone is indeed dead substrate.

---

## Audit Question 3 — Is the Stacks-02JK conormal step a genuine prerequisite?

**No — it is an over-decomposition not found in either Milne or Kleiman.**

### What Milne actually does for Thm 3.1 (the codim-≥2 step)

> "THEOREM 3.1. *A rational map φ: V -- → W from a normal variety V to a complete variety W is defined on an open subset U of V whose complement V \ U has codimension ≥ 2.*"

Milne's proof (p.16–17): "Let U be the largest subset on which φ is defined, and suppose that V \ U has codimension 1. Then there is a prime divisor Z in V \ U. Because V is normal, its associated local ring is a **discrete valuation ring** O_Z with field of fractions k(V). The map φ defines a morphism Spec(k(V)) → W, which the **valuative criterion of properness** (Hartshorne 1977, II 4.7) shows extends to a morphism Spec(O_Z) → W. This implies that φ has a representative defined on an open subset that meets Z in a nonempty set, which is a contradiction."

The proof uses exactly:
1. **Normality** of V (gives O_Z a DVR)
2. **Valuative criterion** of properness for the complete target W

**No conormal sequence. No Stacks 02JK.** The project's stuck node is solving a strictly harder sub-problem than what the reference requires.

### What Milne does for Lemma 3.3 (the codim-1 / group-variety step)

> "LEMMA 3.3. *Let φ: V -- → G be a rational map from a nonsingular variety to a group variety. Then either φ is defined on all of V or the points where it is not defined form a closed subset of pure codimension 1 in V.*"

Proof (p.17–18): Define `Φ: V×V -- → G, (x,y) ↦ φ(x)·φ(y)^{-1}`. Uses divisor theory on V×V (AG 9.2) to show the non-definition locus has pure codimension 1. **No conormal sequence.**

Thm 3.2 is then immediate: "Combine Theorem 3.1 with the next lemma." Lemma 3.3 shows non-definition locus is codim-1 (if nonempty); Thm 3.1 shows for complete target it must be codim ≥ 2; so the non-definition locus is empty.

**Project misidentification:** The stuck node ("02JK conormal isomorphism") corresponds to no step in Milne §I.3. The correct decomposition is:
- Thm 3.1 ↔ normality + valuative criterion (Hartshorne II.4.7) — ~20 LOC in Mathlib terms
- Lemma 3.3 ↔ divisor theory on V×V — standard commutative algebra
- Thm 3.2 ↔ combine above

These prerequisites are all available in Mathlib. The 02JK route is a dead end that does not correspond to either reference.

---

## Audit Question 4 — Bottom line: commit to Route (2), keep both, or is autoduality a show-stopper?

### Route (2) is the superior path, with one real cost

| Factor | Route (1) — Milne Thm 3.2 | Route (2) — Kleiman `rmk:Alb` |
|--------|--------------------------|-------------------------------|
| Stuck node | 27 iters on 02JK (wrong approach) | None (not yet started) |
| Key tool | Valuative criterion + divisor theory on V×V | Comparison Theorem + representability |
| Mathlib availability | DVR + valuative criterion: available; divisor theory on V×V: available | Comparison Theorem: requires Pic representability (A.2.c) |
| Gating | Independent of A.2.c | Gated on A.2.c (Comparison Theorem needs representability) |
| UP delivered on | J (directly) | J^∨; needs autoduality bridge |
| Autoduality cost | N/A | Theta divisor + Poincaré sheaf (Milne Lemmas 6.7–6.9); **no RR** |
| RR dependency | None (Thm 3.2 is RR-free) | None (autoduality is RR-free) |
| Excises | 3 stuck files (CodimOneExtension, Thm32RationalMapExtension, AuslanderBuchsbaum) | Same — fully obsoletes Route (1) cone |

### The autoduality bridge is NOT a show-stopper

The autoduality J^∨ ≅ J (Milne Thm 6.6; Kleiman `rmk:Jac` citing [EGK Thm 2.1]) is:
- Independent of Riemann–Roch
- Stated over a relative base S (not just k̄), so descent is handled
- Non-trivial but bounded: theta divisor, Poincaré sheaf, Lemmas 6.7–6.9 in Milne (≈ 4 lemmas with explicit proofs, pp.105–107)

Compare with Route (1): fixing the stuck node by replacing 02JK with the valuative criterion is also achievable, but Route (1) delivers UP only on J (no autoduality needed) whereas it requires CodimOneExtension + Thm32RationalMapExtension + AuslanderBuchsbaum — three files with substantial sorry loads.

### Recommendation

**Commit to Route (2) and excise the Route (1) cone.** Specifically:

1. **Delete or archive** `CodimOneExtension.lean`, `Thm32RationalMapExtension.lean`, `AuslanderBuchsbaum.lean` as dead substrate. The STRATEGY.md row "A.4.c.0 — EXCISION-PENDING" can be resolved: the cone is excised.

2. **Route (2) implementation plan:**
   - (a) After A.2.c (representability) lands: apply Kleiman `rmk:Alb` via the Comparison Theorem to get `u: C → J^∨` with the UP. This is the `rmk:Alb` lane.
   - (b) Prove autoduality `J^∨ ≅ J` from theta-divisor / Poincaré sheaf (Milne Thm 6.6 or Kleiman `rmk:Jac` / [EGK Thm 2.1]). This replaces the UP on J^∨ with one on J.
   - (c) Compose to get `isAlbaneseFor`.

3. **If Route (2) is not yet available** (A.2.c still far): Route (1) can be **repaired** by replacing the 02JK approach with the valuative-criterion proof of Thm 3.1 (normality → DVR → Hartshorne II.4.7). This is a bounded fix (~20–30 LOC), not 27 more iterations.

**One residual concern:** Kleiman's `rmk:Alb` works over an algebraically closed field k. The project's goal has C/k with k a general field. The Galois-descent step from k̄ to k is needed. Milne Prop 6.4's proof handles this explicitly (pp.104–105) via extending k to a Galois closure and using uniqueness. This descent argument (~10–15 LOC) should be treated as an additional but minor sub-step of Route (2), not a blocker.

---

## Findings Checklist

| Claim in directive | Finding |
|--------------------|---------|
| Route (2) delivers UP from representability | **Confirmed** (Kleiman `rmk:Alb`, lines 3960–3988) |
| Route (2) delivers UP on J^∨ not J | **Confirmed** — `A = Pic⁰_{P/k}` = J^∨ |
| Autoduality bridge needs RR | **Refuted** — Milne Thm 6.6 + Kleiman `rmk:Jac` / EGK; theta divisor only |
| Route (1) is the only path to UP | **Refuted** — Kleiman gives independent path |
| 02JK conormal iso is needed for Route (1) codim-≥2 step | **Refuted** — Milne uses valuative criterion (Hartshorne II.4.7), zero conormal sequence |
| Route (1) cone should be preserved pending audit | **Resolved: excise** — Route (2) confirmed viable, 02JK approach wrong regardless |

---

*Sources consulted:*
- *Kleiman, "The Picard scheme", arXiv:math/0504020: `rmk:Alb` (lines 3960–3988), `rmk:Jac` (lines 3990–4016), `rmk:Ablsch` (lines 3920–3958), `th:cmp` (lines 1384–1399), `th:qpp&p` (line 2935), §5 opening (lines 2836–2933)*
- *Milne, "Abelian Varieties" v2.00: Thm 3.1 (p.16), Thm 3.2 + Lemma 3.3 (p.17), Prop 6.1 (p.104), Prop 6.4 + Remark 6.5 (p.105), Thm 6.6 (p.105), Lemmas 6.7–6.9 (pp.105–107), Summary 6.11 (p.107), §7 intro (p.108)*
- *Project STRATEGY.md (`.archon/STRATEGY.md`)*
