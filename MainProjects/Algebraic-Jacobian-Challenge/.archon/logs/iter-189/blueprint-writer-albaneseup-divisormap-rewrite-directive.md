# Blueprint Writer Directive

## Slug
albaneseup-divisormap-rewrite

## Target chapter
`blueprint/src/chapters/Albanese_AlbaneseUP.tex` — rewrite in place.

## Strategy context

Per iter-188 strategy-critic CHALLENGE addressed via STRATEGY.md major
revision, the A.4.d sub-phase pivoted from the **Sym^g symmetric-power
route** (the route currently described in the chapter) to a
**divisor-map Albanese UP route**. The rationale:

- Sym^g route required formalising `Sym^g(C)` as a SCHEME (the
  $S_g$-quotient of $C^g$), which is an unowned Mathlib gap of
  approximately ~800–1500 LOC and would multiply the A.4.d cost
  considerably.
- Divisor-map route avoids constructing `Sym^g(C)` as a scheme by
  working directly with `Pic^d` via the universal degree-d Cartier
  divisor and Abel–Jacobi morphism `f^P_d : C → Pic^d`.
- The S_g-symmetry of the morphism `C^g → A` (which IS needed) is
  exploited at the LEVEL of the arrow `Pic^g → A` rather than via a
  quotient scheme — this fits naturally with the Yoneda embedding /
  representable-functor framing of `Pic^d_{C/k}`.

The Lean target file `AlgebraicJacobian/Albanese/AlbaneseUP.lean`
remains on standing deferral (iter-200+). This chapter rewrite is
informational + structural; no prover work follows in iter-189.

## Required content (the rewritten chapter)

### Section 1 — Setup and statement (preserve, lightly edit)

Keep the existing setup (`C/\bar k` smooth proper geometrically
irreducible curve of genus $g > 0$, basepoint $P_0 \in C(\bar k)$,
$J := \mathrm{Pic}^0_{C/k}$, identity $\eta_J$). Keep
`thm:albanese_universal_property` with its
`\lean{AlgebraicGeometry.Pic0.albanese_universal_property}` pin and
Milne III §6 Prop 6.1 verbatim quote.

Replace the existing "ROUTE DECISION" prose at the top of the file
(currently committing to Route (ii) Sym^g) with a NEW route decision
prose committing to the **divisor-map Albanese UP** route. The new
route reads: instead of constructing Sym^g(C) as a scheme, use the
universal degree-g Cartier divisor on $C \times \mathrm{Pic}^g_{C/k}$
to build the morphism, descent through the natural transformation
$\Phi : C^g \to \mathrm{Pic}^g$, and then translate $\mathrm{Pic}^g
\to \mathrm{Pic}^0$ by $\mathcal O(-g \cdot P_0)$ (using the basepoint).

### Section 2 — The Abel–Jacobi morphism at the basepoint (preserve)

Keep `lem:abel_jacobi_morphism`
(`\lean{AlgebraicGeometry.Pic0.abelJacobi}`) verbatim. This sub-lemma
is route-independent; it is the moduli-of-degree-0-line-bundles
interpretation packaged as a morphism $C \to J$. No change needed.

### Section 3 — REPLACE Sym^g material with divisor-map material

The current chapter has sections:
- §3 "The $g$-th symmetric power $\mathrm{Sym}^g C$" — REMOVE.
- §4 "The morphism $\mathrm{Sym}^g \varphi$" — REMOVE.
- §5 (or whatever follows) "Birational structure of $\mathrm{Sym}^g \to J$" — REMOVE.
- §6 "Descent through the birational morphism" — REMOVE.

Replace with these new sections:

#### 3.1 — Universal degree-g effective Cartier divisor

```latex
\begin{definition}[Universal degree-g effective Cartier divisor]
  \label{def:universal_degree_g_divisor}
  \lean{AlgebraicGeometry.Pic.universalEffectiveDivisor}
  \uses{def:pic_scheme}
  Let $C/\bar k$ be a smooth projective curve. The component
  $\mathrm{Pic}^g_{C/k}$ of the Picard scheme parametrising degree-g
  line bundles carries a canonical universal degree-g effective
  Cartier divisor $\mathcal D^g_{\mathrm{univ}}$ on $C \times_{\bar k}
  \mathrm{Pic}^g_{C/k}$, characterised by the universal property:
  for every $\bar k$-scheme $T$ and every effective Cartier divisor
  $D \subset C \times_{\bar k} T$ flat of degree $g$ over $T$, there
  is a unique morphism $f_D : T \to \mathrm{Pic}^g_{C/k}$ such that
  $(\mathrm{id}_C \times f_D)^* \mathcal D^g_{\mathrm{univ}} \cong D$
  as effective Cartier divisors.
\end{definition}
```

Source: Kleiman §5 (FGA Explained Pic^d construction); the universal
effective divisor is the Hilbert-scheme-of-points interpretation of
$\mathrm{Pic}^d$.

#### 3.2 — Sum-of-points morphism C^g → Pic^g

```latex
\begin{lemma}[Sum-of-points morphism]
  \label{lem:sum_of_points_morphism}
  \lean{AlgebraicGeometry.Pic.sumOfPoints}
  \uses{def:pic_scheme, def:universal_degree_g_divisor}
  There is a canonical morphism $\Phi : C^g \to \mathrm{Pic}^g_{C/k}$
  characterised by
  \[
    \Phi(P_1, \ldots, P_g) \;:=\; [\mathcal O_C(P_1 + \cdots + P_g)]
    \quad \text{on } \bar k\text{-points},
  \]
  and on $T$-points by the rule: $(P_1, \ldots, P_g) : T \to C^g
  \mapsto$ the unique morphism $T \to \mathrm{Pic}^g_{C/k}$ classifying
  the effective Cartier divisor $\sum_i \Gamma(P_i) \subset C \times T$.
  The morphism $\Phi$ is $S_g$-invariant (in the sense that the
  composition $\Phi \circ \sigma = \Phi$ for every $\sigma \in S_g$
  permuting the factors of $C^g$).
\end{lemma}
```

The S_g-invariance is the KEY observation: since
$\mathcal O_C(P_1 + \cdots + P_g)$ does not depend on the order of the
$P_i$, $\Phi$ factors set-theoretically (and in fact scheme-theoretically
via Yoneda) through the symmetric product — without needing to
CONSTRUCT $\mathrm{Sym}^g C$ as a scheme. The route exploits the fact
that Yoneda-level descent of $\Phi$ to a hypothetical $\mathrm{Sym}^g C$
is unnecessary: we descend directly to $\mathrm{Pic}^g$.

#### 3.3 — Degree-g translate

```latex
\begin{lemma}[Degree-g translate Pic^g → Pic^0]
  \label{lem:degree_g_translate}
  \lean{AlgebraicGeometry.Pic.translateGtoZero}
  \uses{def:pic_scheme}
  Let $P_0 \in C(\bar k)$ be the fixed basepoint and $\mathcal O_C(g
  P_0)$ the corresponding degree-g line bundle. The translate
  \[
    t_g \;\colon\; \mathrm{Pic}^g_{C/k} \;\xrightarrow{\,\sim\,}\;
        \mathrm{Pic}^0_{C/k},
    \qquad [\mathcal L] \;\mapsto\; [\mathcal L \otimes \mathcal
        O_C(-g P_0)],
  \]
  is an isomorphism of $\bar k$-schemes.
\end{lemma>
```

The composition $\iota_{P_0,g} := t_g \circ \Phi^{(1)} : C \to J$
(where $\Phi^{(1)}$ is the degree-1 component, recovered from the
Abel–Jacobi morphism `lem:abel_jacobi_morphism`) is precisely the
Abel–Jacobi morphism of `lem:abel_jacobi_morphism` — verify and add
this as a remark.

#### 3.4 — Sum morphism on the abelian variety

```latex
\begin{lemma}[Sum morphism on the abelian variety]
  \label{lem:sum_morphism_av}
  \lean{AlgebraicGeometry.AbelianVariety.sumMorphism}
  Let $A$ be an abelian variety over $\bar k$. The morphism
  $\mathrm{add}^g : A^g \to A$, $(a_1, \ldots, a_g) \mapsto a_1 +
  \cdots + a_g$, is $S_g$-symmetric (since $A$ is a commutative group
  scheme).
\end{lemma>
```

#### 3.5 — Descent at the morphism level

This is the technical heart of the route. The morphism $\varphi^g
\circ \mathrm{add}^g : C^g \to A$ is $S_g$-symmetric (Lemma 3.4), so
by Yoneda — without constructing $\mathrm{Sym}^g C$ — it factors
through any $S_g$-coequaliser quotient at the level of functors of
points. Crucially, $\Phi : C^g \to \mathrm{Pic}^g$ IS such a
coequaliser at the level of functors of points: for every
$\bar k$-scheme $T$, $\Phi(T) : C(T)^g \to \mathrm{Pic}^g(T)$ is
$S_g$-invariant (Lemma 3.2). So $\varphi^g \circ \mathrm{add}^g$
factors uniquely through $\Phi$:

```latex
\begin{theorem}[Yoneda descent through Pic^g]
  \label{thm:yoneda_descent_pic_g}
  \lean{AlgebraicGeometry.Pic.yonedaDescentToPicg}
  \uses{lem:sum_of_points_morphism, lem:sum_morphism_av,
        thm:rational_map_to_av_extends}
  Let $A$ be an abelian variety over $\bar k$ and $\varphi : C \to A$
  a morphism with $\varphi(P_0) = \eta_A$. There exists a unique
  rational morphism $\widetilde\psi : \mathrm{Pic}^g_{C/k}
  \dashrightarrow A$ such that the diagram
  \[
    \begin{tikzcd}
      C^g \arrow{r}{\varphi^g} \arrow{d}[swap]{\Phi} & A^g
        \arrow{d}{\mathrm{add}^g} \\
      \mathrm{Pic}^g_{C/k} \arrow{r}{\widetilde\psi} & A
    \end{tikzcd}
  \]
  commutes on a dense open of $\mathrm{Pic}^g$ (equivalently, on a
  dense open of $C^g$ that maps surjectively onto it).
\end{theorem}
```

The proof uses the moduli interpretation: a $T$-point
$f : T \to \mathrm{Pic}^g$ classifies a flat-of-degree-g effective
Cartier divisor $D \subset C \times T$, which over an open dense
$T$ corresponds to an unordered $g$-tuple of points $(P_1, \ldots,
P_g) \in C(T)^g$ (modulo $S_g$). The morphism $\widetilde\psi(f) :=
\sum_i \varphi(P_i)$ is well-defined modulo $S_g$ and a rational
morphism on $\mathrm{Pic}^g$ by Yoneda.

#### 3.6 — Extend rational to regular via Theorem 3.2

```latex
\begin{lemma}[Rational map to abelian variety extends]
  \label{lem:yoneda_descent_extends}
  \lean{AlgebraicGeometry.Pic.yonedaDescentExtends}
  \uses{thm:yoneda_descent_pic_g, thm:rational_map_to_av_extends}
  The rational morphism $\widetilde\psi : \mathrm{Pic}^g_{C/k}
  \dashrightarrow A$ of \cref{thm:yoneda_descent_pic_g} extends
  uniquely to a regular morphism
  $\widetilde\psi : \mathrm{Pic}^g_{C/k} \to A$.
\end{lemma>
```

The proof invokes the project's Milne III.3.2 theorem
`thm:rational_map_to_av_extends`
(`AlgebraicGeometry.rational_map_to_av_extends`).

#### 3.7 — Translate to Pic^0

```latex
\begin{lemma}[Translate of psi to Pic^0]
  \label{lem:psi_translate_pic0}
  \lean{AlgebraicGeometry.Pic.psiTranslateToPic0}
  \uses{lem:yoneda_descent_extends, lem:degree_g_translate}
  The composition $\psi := \widetilde\psi \circ t_g^{-1} :
  \mathrm{Pic}^0_{C/k} \to A$ is a homomorphism of group schemes.
\end{lemma>
```

#### 3.8 — Final assembly of `thm:albanese_universal_property`

Replace the existing proof block of `thm:albanese_universal_property`
with one that uses the chain
`def:universal_degree_g_divisor` →
`lem:sum_of_points_morphism` →
`thm:yoneda_descent_pic_g` →
`lem:yoneda_descent_extends` →
`lem:psi_translate_pic0` →
`thm:albanese_universal_property`.

Show that $\psi \circ \iota_{P_0}(Q) = \varphi(Q)$ for every
$\bar k$-point $Q \in C(\bar k)$ (recovering Milne III.3.10's
uniqueness from the moduli construction).

### Section 4 — Alternative-route history (preserve as % NOTE)

The existing chapter has a "ROUTE DECISION (iter-174, refined
iter-175)" prose at the top of the file recording the moduli /
autoduality route that was rejected. PRESERVE this as a % NOTE block
at the END of the rewritten chapter, retaining the historical
context. Add a NEW paragraph noting:

> "(iter-188 strategy-critic CHALLENGE pivoted A.4.d from Sym^g to
> divisor-map UP per the analysis above; the Sym^g sections of this
> chapter have been rewritten in place. The Sym^g route's
> sub-lemmas — `def:symmetric_power_curve`, `lem:symmetric_product_av_map`,
> `lem:symmetric_product_to_jacobian`, and
> `lem:descent_through_birational_sigma` — are retired and excised.)"

## Specific declarations to REMOVE

- `def:symmetric_power_curve` (and its `\lean{AlgebraicGeometry.Pic0.SymmetricPower}` pin)
- `lem:symmetric_product_av_map`
- `lem:symmetric_product_to_jacobian`
- `lem:descent_through_birational_sigma`
- All prose sections describing the Sym^g construction.

## Specific declarations to ADD (with `\lean{...}` pins)

- `def:universal_degree_g_divisor` — `AlgebraicGeometry.Pic.universalEffectiveDivisor`
- `lem:sum_of_points_morphism` — `AlgebraicGeometry.Pic.sumOfPoints`
- `lem:degree_g_translate` — `AlgebraicGeometry.Pic.translateGtoZero`
- `lem:sum_morphism_av` — `AlgebraicGeometry.AbelianVariety.sumMorphism`
- `thm:yoneda_descent_pic_g` — `AlgebraicGeometry.Pic.yonedaDescentToPicg`
- `lem:yoneda_descent_extends` — `AlgebraicGeometry.Pic.yonedaDescentExtends`
- `lem:psi_translate_pic0` — `AlgebraicGeometry.Pic.psiTranslateToPic0`

## Specific declarations to PRESERVE (verbatim where possible)

- `thm:albanese_universal_property` (the statement; proof body
  replaced as described).
- `lem:abel_jacobi_morphism` (verbatim — route-independent).
- The Milne III §6 Proposition 6.1 and Summary 6.11 verbatim quotes.

## Mathlib note (out-of-scope acknowledgement)

The `Pic^g_{C/k}` representable functor is built by Route A.2.c
(`Picard_FGAPicRepresentability.tex`); the universal degree-g
divisor exists by the Hilbert-scheme-of-points interpretation
(Nitsure §5). Do NOT include the construction of `Pic^g_{C/k}` in
this chapter — it is upstream content.

## References

- `references/abelian-varieties.pdf` (Milne) — Proposition 6.1 + Summary 6.11.
- `references/kleiman-picard.pdf` — Pic^d construction.
- `references/nitsure-hilbert-quot.pdf` — Hilbert-scheme-of-points / universal effective divisor.
- `references/mumford-abelian-varieties.pdf` — translation morphisms.

## Out of scope

- Do NOT add `\leanok` or `\mathlibok` markers (managed by sync_leanok).
- Do NOT add new chapter files (single-chapter directive).
- Do NOT speculate on substrate construction of `Pic^g_{C/k}` — that
  is A.2.c.
- Do NOT extend the Sym^g sections; remove them entirely.

## Estimated effort

Full rewrite ~600-900 LOC in the chapter (replacing ~500 LOC of Sym^g
material with ~700 LOC of divisor-map material). Estimated ~1-2 hours
for the writer.
