# Blueprint Review Report

## Slug
route171b

## Iteration
171

## Top-level summaries

### Incomplete parts

- `AbelianVarietyRigidity.tex` / `prop:genusZero_curve_iso_P1` (L1572–L1613, plus
  `rmk:genusZero_iso_subbuild` L1615–L1625): currently a single 50-line statement
  block with a 14-line Hartshorne IV.1.3.5 proof sketch plus a remark frankly
  declaring "Mathlib has no Riemann–Roch theorem for curves, no divisor class
  group machinery at this level, and no $\mathbb P^1$-classification of rational
  curves." Per the iter-171 directive (and STRATEGY.md row "genus-0 RR bridge"),
  this block must now be expanded into a 4-sub-section in-tree sub-build
  matching `analogies/rrbridge-survey.md` option (1) — the four Hartshorne
  ingredients (divisor of a closed point, RR dimension formula on a genus-0
  curve, linear equivalence, "rational ⟹ ≅ ℙ¹"). The current block is *not*
  prover-ready as-is. See the unstarted-phase proposal below.
- `Jacobian.tex` / Route A sub-phase paragraphs (L347–L432): A.1/A.2/A.3/A.4 are
  decomposed at the level of *bullets inside the proof of
  `thm:nonempty_jacobianWitness`*. The bullets carry LOC/iter estimates, name
  the Mathlib namespaces, and identify entry points, but they are not yet
  prover-ready: no per-sub-phase `\lean{...}` hints, no per-sub-phase
  declarations and labels for the four sub-functors (`RelativeSpec`,
  `LineBundle.Pullback`, `RelativePicard`, `Pic_repr`, `IdentityComponent`,
  `DegreeMap`, `AlbaneseUP`). To open prover lanes per the iter-171 commitment
  in STRATEGY.md they need sub-chapter expansion. See proposals below.

### Lean difficulty quality

- `Jacobian.tex` / `\lean{AlgebraicGeometry.positiveGenusWitness}` (def:positiveGenusWitness, L578):
  the named target is well-formed and matches the Lean declaration, but the
  body of this declaration is gated on the entire Route A pipeline (A.1–A.4);
  the chapter currently does not pin which sub-witness inside the prover
  closure will land first. This is a soon-severity rather than must-fix for
  iter-171 (no active prover lane on this target).

### Citation discipline

- `AbelianVarietyRigidity.tex` / `lem:hom_Ga_to_av_trivial` (L1236), `lem:hom_from_Ga_trivial` (L1366):
  the `% NOTE (iter-164)` at L1243–L1246 honestly discloses that the Milne
  Prop 3.9 verbatim quotes "were NOT re-rendered from references/abelian-varieties.pdf
  this session; they are reproduced from the verified in-tree copy." This is
  honest disclosure rather than fabrication — the quotes were verified in a
  prior session — but it is a soon-severity hygiene item: an iter that *can*
  render PDFs should re-verify, and the writer report for the chapter should
  list `abelian-varieties.pdf` under References-consulted to keep the chain
  auditable. Not a must-fix-this-iter for the gmScalingP1 prover lane.

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/JacobianRouteA1_RelativeSpec.tex`

**Covers**: `AlgebraicJacobian/Picard/RelativeSpec.lean` (to-be-created; first
sub-file of A.1)
**Strategy phase**: Route A.1 — Relative Picard / line-bundle pullback (sub-phase
A.1.a: `RelativeSpec` functor)
**Why now**: A.1.a is the smallest standalone Mathlib entry point per the iter-123
audit (~700 LOC midpoint); writing the blueprint this iter opens iter-172 as the
first prover lane firing for Route A, unblocking the longest critical path
(~33–54 iters total for Route A) ahead of the genus-0 stack closing.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:RelativeSpec}` — the relative-spec functor
   $\mathrm{RelativeSpec} \colon (\mathrm{Sch}/S)^{\mathrm{op}} \to \mathrm{Sch}/S$
   sending a quasi-coherent $\mathcal O_S$-algebra to its relative spectrum.
   `\lean{AlgebraicGeometry.Scheme.RelativeSpec}` [expected]. Source: Stacks Tag
   01LL (`stacks-coherent.md`).
2. `\lemma` `\label{lem:RelativeSpec_isAffine}` — for each $T \in \mathrm{Sch}/S$
   and quasi-coherent $\mathcal O_T$-algebra $\mathcal A$, the structure map
   $\mathrm{RelativeSpec}_T \mathcal A \to T$ is affine.
   `\lean{AlgebraicGeometry.Scheme.RelativeSpec_isAffine}` [expected]. Source:
   Stacks Tag 01LM.
3. `\theorem` `\label{thm:RelativeSpec_adjunction}` — $\mathrm{RelativeSpec}$ is
   right-adjoint to the global-sections functor on affine $S$-schemes.
   `\lean{AlgebraicGeometry.Scheme.RelativeSpec_adjunction}` [expected]. Source:
   Stacks Tag 01LN.
4. `\lemma` `\label{lem:RelativeSpec_baseChange}` — $\mathrm{RelativeSpec}$
   commutes with base change.
   `\lean{AlgebraicGeometry.Scheme.RelativeSpec_baseChange}` [expected]. Source:
   Stacks Tag 01LQ.

**`\uses` skeleton**:
- `lem:RelativeSpec_isAffine` uses `def:RelativeSpec`
- `thm:RelativeSpec_adjunction` uses `def:RelativeSpec`, `lem:RelativeSpec_isAffine`
- `lem:RelativeSpec_baseChange` uses `def:RelativeSpec`, `thm:RelativeSpec_adjunction`

**Main theorem proof strategy**: $\mathrm{RelativeSpec}$ is built by gluing
$\Spec \mathcal A(U)$ for an affine open cover $\{U\}$ of $T$; the affineness
of each chart gives affineness over $T$. The adjunction is the affine
adjunction $\Gamma \dashv \Spec$ globalised along the gluing. Base-change
follows from the fact that fibered product commutes with $\Spec$ on the affine
charts, plus that the gluing is base-change-stable.

**References for writer**:
- `references/stacks-coherent.md` → Tag 01LL–01LQ
- `references/hartshorne-algebraic-geometry.md` → Ch. II §5 Exercise 5.17

### Proposed chapter: `blueprint/src/chapters/JacobianRouteA1_LineBundlePullback.tex`

**Covers**: `AlgebraicJacobian/Picard/LineBundle.lean` (to-be-created; second
sub-file of A.1, building on A.1.a)
**Strategy phase**: Route A.1 — Relative Picard / line-bundle pullback
(sub-phase A.1.b)
**Why now**: A.1.b is the line-bundle-pullback half of A.1; it is independent
of A.1.c (the `RelPic` functor itself) and can be written in parallel with
A.1.a's prover scaffold. Naming and signature pinning this iter prevents the
A.1.c blueprint from inventing incompatible line-bundle conventions.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:LineBundle}` — a line bundle on a scheme $X$ is a
   locally free $\mathcal O_X$-module of rank 1.
   `\lean{AlgebraicGeometry.LineBundle}` [expected]. Source: Hartshorne II.6
   (`hartshorne-algebraic-geometry.md`).
2. `\definition` `\label{def:LineBundle_pullback}` — pullback of a line bundle
   along a scheme morphism $f \colon X \to Y$.
   `\lean{AlgebraicGeometry.LineBundle.pullback}` [expected]. Source: Hartshorne
   II.7.1.
3. `\lemma` `\label{lem:LineBundle_pullback_compatible}` — pullback respects
   composition and identities, giving a functor $f^* \colon \mathrm{LineBundle}\,Y
   \to \mathrm{LineBundle}\,X$. `\lean{AlgebraicGeometry.LineBundle.pullback_compatible}`
   [expected].
4. `\definition` `\label{def:LineBundle_relative}` — relative line bundle on a
   product $C \times_k T$, equipped with its $T$-flat structure.
   `\lean{AlgebraicGeometry.LineBundle.relative}` [expected]. Source: FGA
   Explained Ch. 9 §9.2.

**`\uses` skeleton**:
- `def:LineBundle_pullback` uses `def:LineBundle`
- `lem:LineBundle_pullback_compatible` uses `def:LineBundle_pullback`
- `def:LineBundle_relative` uses `def:LineBundle`, `def:LineBundle_pullback`

**Main theorem proof strategy**: Line bundles are constructed as the invertible
objects in the tensor-product structure on `Module.LocallyFree.rank 1`; pullback
is induced from `Sheaf.Pullback`. Functoriality reduces to functoriality of
`PullbackSheaf` and naturality of `Module.LocallyFree.rank`.

**References for writer**:
- `references/hartshorne-algebraic-geometry.md` → II.6, II.7
- `references/fga-explained.md` → Ch. 9 §9.2 (relative line bundles)

### Proposed chapter: `blueprint/src/chapters/JacobianRouteA1_RelPicFunctor.tex`

**Covers**: `AlgebraicJacobian/Picard/RelPicFunctor.lean` (to-be-created; third
sub-file of A.1)
**Strategy phase**: Route A.1 — Relative Picard / line-bundle pullback
(sub-phase A.1.c: the relative-Picard set-functor)
**Why now**: A.1.c assembles A.1.a (`RelativeSpec`) and A.1.b
(`LineBundle.Pullback`) into the set-valued functor whose representability is
A.2's target. Pinning the functor signature this iter constrains A.2's
blueprint to a compatible representability target.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:RelPicSharp}` — the pre-Picard functor
   $\Pic^\sharp_{C/k}(T) := \Pic(C_T) / \pi^*\Pic(T)$ on
   $(\mathrm{Sch}/k)^{\mathrm{op}}$. `\lean{AlgebraicGeometry.RelPicSharp}` [expected].
   Source: FGA Explained Ch. 9 §9.2.
2. `\lemma` `\label{lem:RelPicSharp_groupValued}` — $\Pic^\sharp_{C/k}$ refines
   to a group-valued functor via the tensor-product group structure on $\Pic$.
   `\lean{AlgebraicGeometry.RelPicSharp.groupValued}` [expected]. Source: Hartshorne
   III.4.
3. `\definition` `\label{def:RelPicEtale}` — étale sheafification when $k$ is
   not algebraically closed. `\lean{AlgebraicGeometry.RelPicEtale}` [expected].
   Source: FGA Explained Ch. 9 §9.3.

**`\uses` skeleton**:
- `lem:RelPicSharp_groupValued` uses `def:RelPicSharp`, `lem:LineBundle_pullback_compatible`
- `def:RelPicEtale` uses `def:RelPicSharp`, `lem:RelPicSharp_groupValued`

**Main theorem proof strategy**: $\Pic^\sharp_{C/k}$ is the cokernel of the
pullback-via-$\pi$ map between $\Pic$ groups; this is computed in `Sets` (then
upgraded to `AbGrp` via the tensor-product structure). Étale sheafification is
the standard Mathlib `Sites.Sheafification` applied to the étale site.

**References for writer**:
- `references/fga-explained.md` → Ch. 9 §9.2, §9.3
- `references/hartshorne-algebraic-geometry.md` → III.4

### Proposed chapter: `blueprint/src/chapters/JacobianRouteA2_HilbertQuot.tex`

**Covers**: `AlgebraicJacobian/Picard/QuotScheme.lean`,
`AlgebraicJacobian/Picard/HilbertScheme.lean`,
`AlgebraicJacobian/Picard/PicRepresentability.lean` (to-be-created consolidated
chapter)
**Strategy phase**: Route A.2 — Hilbert/Quot + FGA `Pic_{C/k}` representability
(dominant block, ~2200–3000 LOC, ~15–25 iters)
**Why now**: A.2 is the largest and riskiest sub-build of Route A; its
flattening-stratification half and Quot-construction half each clear at
~1500 LOC. Writing the blueprint this iter pins the conceptual decomposition so
the prover-lane planner does not re-invent the structure when (A.1) lands.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:GenericFlatness}` — the generic-flatness stratum of
   a coherent sheaf on a Noetherian base.
   `\lean{AlgebraicGeometry.GenericFlatness}` [expected]. Source: Nitsure §4
   (`nitsure-hilbert-quot.md`).
2. `\theorem` `\label{thm:FlatteningStratification}` — for a quasi-coherent
   sheaf $\mathcal F$ on $C \times T$ flat over $T$, there exists a
   stratification of $T$ such that the Hilbert polynomial of $\mathcal F$
   restricted to each stratum is constant. `\lean{AlgebraicGeometry.FlatteningStratification}`
   [expected]. Source: Nitsure §4.4.
3. `\definition` `\label{def:QuotFunctor}` — the Quot functor
   $\mathrm{Quot}_{C/k}^{\mathcal F, P}$ classifying surjective quotients
   $\mathcal F \twoheadrightarrow \mathcal G$ on $C_T$ with Hilbert polynomial $P$
   on every fibre. `\lean{AlgebraicGeometry.QuotFunctor}` [expected]. Source:
   Nitsure §5.1.
4. `\theorem` `\label{thm:QuotRepresentability}` — $\mathrm{Quot}_{C/k}^{\mathcal F, P}$
   is representable by a projective $k$-scheme.
   `\lean{AlgebraicGeometry.QuotFunctor.representability}` [expected]. Source:
   Nitsure §5.5 (the construction; "FGA's Theorem 5.14").
5. `\definition` `\label{def:HilbertScheme}` — $\mathrm{Hilb}_{C/k}^P$ as
   $\mathrm{Quot}_{C/k}^{\mathcal O_C, P}$. `\lean{AlgebraicGeometry.HilbertScheme}`
   [expected]. Source: Nitsure §5.6.
6. `\theorem` `\label{thm:PicRepresentability}` — for $C$ smooth proper
   geometrically connected with a $k$-rational point, $\Pic_{C/k}$ is
   representable by a $k$-group scheme locally of finite type. (After
   étale-sheafification of A.1.c.)
   `\lean{AlgebraicGeometry.PicScheme}` [expected]. Source: Kleiman §4
   (`kleiman-picard.md`); FGA 232.

**`\uses` skeleton**:
- `thm:FlatteningStratification` uses `def:GenericFlatness`
- `thm:QuotRepresentability` uses `def:QuotFunctor`, `thm:FlatteningStratification`
- `def:HilbertScheme` uses `def:QuotFunctor`
- `thm:PicRepresentability` uses `def:RelPicEtale`, `thm:QuotRepresentability`,
  `def:HilbertScheme`

**Main theorem proof strategy**: Flattening reduces to controlling the local
Tor-functors; the Quot functor is constructed via the Grassmannian of a
sufficiently-twisted globalisation $H^0(C, \mathcal F(m))$ for $m \gg 0$
(Castelnuovo–Mumford), and the cohomological-base-change theorem (Stacks Tag
02KH) controls the Hilbert polynomial in families. Representability of
$\Pic_{C/k}$ is via the relative-divisor Hilbert scheme $\mathrm{Hilb}_{C/k}^1$,
quotiented by linear equivalence — the FGA 232 construction. Each step
requires the cohomological-base-change layer underneath (Stacks 02KH), which is
partially in Mathlib (predicate-only, theorem absent).

**References for writer**:
- `references/nitsure-hilbert-quot.md` → §4 (flattening), §5 (Quot construction)
- `references/kleiman-picard.md` → §4 (Pic existence), §5 (Pic identity component)
- `references/fga-explained.md` → Ch. 5 (Hilbert and Quot, with FGA 232 citation)
- `references/stacks-coherent.md` → Tag 02KH (cohomological base change)

**Subphase choices exposed**:
- *Quot via Castelnuovo–Mumford regularity (Nitsure §5)* vs. *Quot via the
  flat-family-of-quotients functor directly* (some references reverse the
  order). Recommendation: follow Nitsure §5 — it is the standard reference
  and is already in `references/`, and decomposes naturally into
  flattening-then-Grassmannian sub-builds. Plan-agent decision.
- *Cohomological-base-change as a separate sub-chapter or absorbed into A.2*:
  if Mathlib's `Mathlib.AlgebraicGeometry.Cohomology.BaseChange` lands during
  the build, A.2 should consume that anchor rather than re-derive in-tree.
  Recommendation: write A.2's blueprint assuming consumption (cleaner
  decomposition), with a `% NOTE` flagging the fallback if the Mathlib piece
  stalls.

### Proposed chapter: `blueprint/src/chapters/JacobianRouteA3_Pic0.tex`

**Covers**: `AlgebraicJacobian/Picard/Pic0.lean`,
`AlgebraicJacobian/Picard/IdentityComponent.lean` (to-be-created)
**Strategy phase**: Route A.3 — Pic⁰ identity component + degree map (~600–900 LOC,
~5–8 iters)
**Why now**: A.3 is gated downstream of A.2 (it consumes the represented
`Pic_{C/k}` group scheme) but the blueprint decomposition is independent —
identity-component and degree-map theory are standard and can be written now,
so when A.2 lands the prover work begins immediately rather than after a
blueprint-writer round.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:IdentityComponent}` — the identity component
   $G^0 \subseteq G$ of a group scheme locally of finite type over a field.
   `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent}` [expected]. Source:
   Kleiman §5 (Lem. `agps`).
2. `\lemma` `\label{lem:IdentityComponent_geomIrred}` — $G^0$ is geometrically
   irreducible and open-closed in $G$, finite type, commuting with field
   extension. `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.geomIrred}`
   [expected]. Source: Kleiman §5 Lem. `agps`(3).
3. `\definition` `\label{def:DegreeMap}` — the degree map
   $\Pic_{C/k} \to \underline{\mathbb Z}_k$ (locally constant via base change of
   $R^0 \pi_*$). `\lean{AlgebraicGeometry.PicScheme.degreeMap}` [expected].
   Source: Kleiman §5 Prp. `prp:pic0`.
4. `\theorem` `\label{thm:Pic0_smooth_proper}` — for $C$ smooth proper of genus
   $g$, $\Pic^0_{C/k} := \ker(\mathrm{deg})$ is smooth proper of dimension $g$.
   `\lean{AlgebraicGeometry.Pic0Scheme.smoothProper}` [expected]. Source:
   Kleiman §5 Cor. `cor:sm`, Cor. `cor:ch0`.

**`\uses` skeleton**:
- `lem:IdentityComponent_geomIrred` uses `def:IdentityComponent`
- `def:DegreeMap` uses `thm:PicRepresentability`
- `thm:Pic0_smooth_proper` uses `def:IdentityComponent`, `def:DegreeMap`,
  `lem:IdentityComponent_geomIrred`, `def:genus`

**Main theorem proof strategy**: $G^0$ is constructed as the open-and-closed
subscheme containing the identity — the connected component of the structure
sheaf's spectrum. Degree of a line bundle is the integer locally constant on
the étale base (Mathlib's `LocallyConstant.lean` plus `R^0 f_*`). Smoothness of
$\Pic^0$ comes from the deformation-theoretic identification of the tangent
space at the identity with $H^1(C, \mathcal O_C)$ (Kleiman Cor. cor:sm) plus
homogeneity of the group action.

**References for writer**:
- `references/kleiman-picard.md` → §5 (Lem. `agps`, Prp. `prp:pic0`,
  Cor. `cor:sm`, Cor. `cor:ch0`)

### Proposed chapter: `blueprint/src/chapters/JacobianRouteA4_AlbaneseUP.tex`

**Covers**: `AlgebraicJacobian/Picard/AlbaneseUniversalProperty.lean`
(to-be-created)
**Strategy phase**: Route A.4 — Albanese UP of Pic⁰ (~900–1200 LOC, ~7–11 iters)
**Why now**: A.4 is the *only* Route A sub-phase that consumes already-proven
in-tree assets (Rigidity Lemma + Cor 1.2 + Cor 1.5 of
`AbelianVarietyRigidity.tex`). It is therefore the cleanest blueprint to write
now: every named premise resolves to an actual project declaration. The proof
follows Milne §III.6 (~3 pages) which is locally rendered in
`references/abelian-varieties.pdf` (Milne).

**Key declarations** (in dependency order):
1. `\definition` `\label{def:AlbaneseEmbedding}` — the Abel–Jacobi morphism
   $\iota_P \colon C \to \Pic^0_{C/k}$ at a marked $k$-point $P$.
   `\lean{AlgebraicGeometry.AlbaneseEmbedding}` [expected]. Source: Milne
   Proposition 6.1 (`abelian-varieties.pdf`).
2. `\theorem` `\label{thm:AlbaneseUP_pointed}` — for every smooth proper
   geometrically irreducible group scheme $A$ over $k$ and every $f \colon C \to A$
   with $f(P) = \eta_A$, there is a unique morphism of group schemes
   $g \colon \Pic^0_{C/k} \to A$ with $f = \iota_P \circ g$.
   `\lean{AlgebraicGeometry.Pic0Scheme.AlbaneseUP}` [expected]. Source: Milne
   Proposition 6.1 / 6.4.
3. `\lemma` `\label{lem:AlbaneseEmbedding_isAlbanese}` — `def:IsAlbanese` is
   satisfied by `Pic0Scheme` for every $P \in C(k)$.
   `\lean{AlgebraicGeometry.Pic0Scheme.isAlbaneseFor}` [expected].
4. `\theorem` `\label{thm:positiveGenusWitness_closure}` — the body of
   `def:positiveGenusWitness` closes from `lem:AlbaneseEmbedding_isAlbanese`.
   No new `\lean{}` (closes the existing
   `AlgebraicGeometry.positiveGenusWitness` body).

**`\uses` skeleton**:
- `def:AlbaneseEmbedding` uses `thm:Pic0_smooth_proper`
- `thm:AlbaneseUP_pointed` uses `def:AlbaneseEmbedding`, `thm:rigidity_lemma`,
  `lem:hom_additivity_over_product`, `lem:av_regular_map_is_hom`,
  `lem:rational_map_to_av_extends`
- `lem:AlbaneseEmbedding_isAlbanese` uses `def:IsAlbanese`,
  `def:AlbaneseEmbedding`, `thm:AlbaneseUP_pointed`
- `thm:positiveGenusWitness_closure` uses `def:positiveGenusWitness`,
  `lem:AlbaneseEmbedding_isAlbanese`

**Main theorem proof strategy**: The Abel–Jacobi embedding is
$Q \mapsto [\mathcal O_C(Q - P)]$, well-defined as a $\Pic^0$-valued function
since $\deg(\mathcal O_C(Q - P)) = 0$. The universal property of Milne 6.1 is
proved by extending a rational map (Milne Thm 3.2 = `lem:rational_map_to_av_extends`,
already retained as Route-A-only in `AbelianVarietyRigidity.tex`), then applying
Cor 1.5 (`lem:hom_additivity_over_product`) to decompose into translation +
homomorphism, then Cor 1.2 (`lem:av_regular_map_is_hom`) to pin the
homomorphism. Char-free. All four named premises are already proven
axiom-clean in tree (iter-162); this chapter is the first one where Route A's
prover lane can fire entirely on in-tree dependencies.

**References for writer**:
- `references/abelian-varieties.md` → §III.6 (Milne Prop 6.1, 6.4 — Albanese UP)
- `references/kleiman-picard.md` → §5 (Albanese property of Pic⁰)

**Subphase choices exposed**:
- *Closing Lemma 3.3 (codim-1 indeterminacy) via Weil divisors* vs. *closing it
  via valuative-criterion-at-each-codim-1-point*. The directive in
  `analogies/thm32-extend.md` already recommends the latter as the
  Mathlib-friendlier route; the chapter should commit to that recommendation
  and flag the Weil-divisor framing as the unimplemented alternative.
  Recommendation: valuative-pointwise. Plan-agent confirms.

### Proposed chapter: `blueprint/src/chapters/RRBridgeGenus0_P1.tex`

**Covers**: `AlgebraicJacobian/RiemannRoch/Genus0CurveIsoP1.lean` (to-be-created
new file hosting the in-tree RR sub-build) plus the new in-tree RR primitives
(divisors, RR on a genus-0 curve, linear equivalence)
**Strategy phase**: genus-0 RR bridge — `genusZero_curve_iso_P1` (in-tree
sub-build COMMITTED iter-171, ~1500–2500 LOC, ~12–20 iters)
**Why now**: iter-171 commits to closing the keystone `genusZero_curve_iso_P1`
in-tree via `rrbridge-survey.md` option (1). The current
`prop:genusZero_curve_iso_P1` block of `AbelianVarietyRigidity.tex` (L1572–L1613)
+ remark `rmk:genusZero_iso_subbuild` is a 50-line "Mathlib gap" disclosure —
*not* prover-ready as 4 sub-decomposition lanes. The 4 Hartshorne IV.1.3.5
ingredients (divisor of a closed point, RR dimension formula, linear
equivalence, "rational ⟹ ≅ ℙ¹") are mutually serial except RR.1
(`WeilDivisor` on a scheme), which is parallel-startable — so writing the
sub-chapter this iter unblocks the first RR-bridge prover lane in iter-172.

**Key declarations** (in dependency order, mirroring the rrbridge-survey.md
table):

*Sub-phase RR.1: Weil divisor on a scheme*

1. `\definition` `\label{def:WeilDivisor}` — for an integral Noetherian scheme
   $X$, a Weil divisor is a finite formal $\mathbb Z$-linear combination of
   codimension-1 closed integral subschemes (prime divisors).
   `\lean{AlgebraicGeometry.WeilDivisor}` [expected]. Source: Hartshorne II.6.
2. `\definition` `\label{def:WeilDivisor_ofPoint}` — the divisor of a closed
   point $P \in C(\bar k)$ on a smooth curve $C$.
   `\lean{AlgebraicGeometry.WeilDivisor.ofPoint}` [expected]. Source: Hartshorne
   II.6.
3. `\definition` `\label{def:WeilDivisor_degree}` — degree of a Weil divisor on
   a complete curve. `\lean{AlgebraicGeometry.WeilDivisor.degree}` [expected].
   Source: Hartshorne IV.1.

*Sub-phase RR.2: RR formula on a genus-0 curve*

4. `\theorem` `\label{thm:RiemannRoch_genus0}` — for a smooth proper
   geometrically irreducible curve $C$ over $\bar k$ with $\genus(C) = 0$ and a
   divisor $D$ on $C$, $\dim_{\bar k} H^0(C, \mathcal O_C(D)) -
   \dim_{\bar k} H^0(C, \mathcal O_C(K_C - D)) = \deg D + 1$, where $K_C$ is the
   canonical divisor (also of degree $-2$ in genus 0).
   `\lean{AlgebraicGeometry.RiemannRoch.genus0}` [expected]. Source: Hartshorne
   IV.1.3 specialised to $g = 0$.

*Sub-phase RR.3: $\mathcal O_C(P)$ has $h^0 = 2$ and gives a map to $\mathbb P^1$*

5. `\definition` `\label{def:LinearEquivalence}` — linear equivalence
   $D \sim D'$ of two divisors. `\lean{AlgebraicGeometry.WeilDivisor.LinearEquiv}`
   [expected]. Source: Hartshorne II.6.
6. `\lemma` `\label{lem:globalSections_OC_P}` — under the hypotheses of RR.2
   with $D = P$ a closed point, $H^0(C, \mathcal O_C(P))$ is a 2-dimensional
   $\bar k$-vector space. `\lean{AlgebraicGeometry.RR.h0_OC_P}` [expected].
   Source: Hartshorne IV.1.3.5.

*Sub-phase RR.4: "rational ⟹ ≅ ℙ¹"*

7. `\theorem` `\label{thm:rationalCurve_iso_P1}` — a smooth proper geometrically
   irreducible curve $C$ over $\bar k$ admitting a degree-1 morphism $C \to
   \mathbb P^1$ is isomorphic to $\mathbb P^1$.
   `\lean{AlgebraicGeometry.RationalCurve.iso_P1}` [expected]. Source:
   Hartshorne I.6.12 + II.6.10.1.
8. `\theorem` `\label{thm:genusZero_curve_iso_P1_closure}` — the closure of
   `prop:genusZero_curve_iso_P1`. No new `\lean{}` (closes the existing
   `AlgebraicGeometry.genusZero_curve_iso_P1`).

**`\uses` skeleton**:
- `def:WeilDivisor_ofPoint` uses `def:WeilDivisor`
- `def:WeilDivisor_degree` uses `def:WeilDivisor`
- `thm:RiemannRoch_genus0` uses `def:WeilDivisor`, `def:WeilDivisor_degree`,
  `def:genus`
- `def:LinearEquivalence` uses `def:WeilDivisor`
- `lem:globalSections_OC_P` uses `def:WeilDivisor_ofPoint`,
  `thm:RiemannRoch_genus0`
- `thm:rationalCurve_iso_P1` uses `def:LinearEquivalence`
- `thm:genusZero_curve_iso_P1_closure` uses `lem:globalSections_OC_P`,
  `thm:rationalCurve_iso_P1`

**Main theorem proof strategy**: Take $P \neq Q$ two distinct $\bar k$-points
on $C$ (exist since $C$ is infinite over an algebraically closed field). Apply
RR with $D = P - Q$ (deg 0): $\deg(K - D) = -2$ so $l(K - D) = 0$, then
$l(D) = 0 + 1 - 0 = 1$ forces $D$ effective, hence $P \sim Q$. By RR.4 a
curve admitting $P \sim Q$ for two distinct points is rational
(Hartshorne II.6.10.1: produce the degree-1 map $C \to \mathbb P^1$ from the
global sections of $\mathcal O_C(P)$ via RR.3), and a smooth proper rational
curve over $\bar k$ is $\cong \mathbb P^1$ (Hartshorne I.6.12).

**References for writer**:
- `references/hartshorne-algebraic-geometry.md` → II.6 (divisors), IV.1
  (Riemann–Roch), I.6.12 (rational ⟹ ℙ¹)
- `analogies/rrbridge-survey.md` — full Mathlib-gap audit + the 4-ingredient
  decomposition this proposal mirrors.

**Subphase choices exposed**:
- *Weil divisors as the divisor framework* vs. *Cartier divisors* (or both;
  they coincide on a smooth curve). Mathlib's
  `MeromorphicOn.divisor` is analytic, not algebraic; `CommRing.Pic R` is
  ring-level only. Recommendation: build Weil divisors (Hartshorne idiom,
  cleanest specialization to a smooth curve), defer Cartier-on-general-scheme
  until a downstream consumer needs it.
- *Cohomology layer for RR.2*: the project already has
  `\genus C = \dim_{\bar k} H^1(C, \mathcal O_C)` via the
  `Scheme.HModule k F 1` layer. The full RR statement requires
  $H^0(C, \mathcal O_C(D))$ and $H^0(C, \mathcal O_C(K_C - D))$ for arbitrary
  divisors $D$; this needs `H^0` of an arbitrary invertible sheaf, *plus*
  $\mathcal O_C(D)$ as an invertible sheaf attached to a Weil divisor.
  Recommendation: factor RR.2 into a separate sub-chapter
  `RRBridgeGenus0_RR2_Cohomology.tex` if the LOC envelope exceeds ~600 LOC
  (likely, per the analogist estimate of ~1500–2500 LOC total).

### Proposed chapter outline: `blueprint/src/chapters/AbelianVarietyRigidity.tex` (split / refactor reflection)

**Covers**: `AlgebraicJacobian/RigidityLemma.lean` +
`AlgebraicJacobian/AbelianVarietyRigidity.lean` +
`AlgebraicJacobian/Genus0BaseObjects.lean` (post-iter-171 file split)
**Strategy phase**: Refactor — AVR split (housekeeping; iter-171 lane)
**Why now**: iter-171 splits the 1198-LOC AVR Lean file into `RigidityLemma.lean`
(Mumford chain + Cor 1.5 + Cor 1.2, axiom-clean — the upstream half) and
`AbelianVarietyRigidity.lean` (genus-0 final assembly, the 2 gated sorries —
the downstream half). The blueprint chapter `AbelianVarietyRigidity.tex`
covers both halves via its current `% archon:covers ... AbelianVarietyRigidity.lean
Genus0BaseObjects.lean` annotation. After the split, the chapter's `% archon:covers`
line must add `RigidityLemma.lean`; no content changes are required (the
chapter already covers both halves in its prose), only the `% archon:covers`
metadata update.

**Key declarations**: no new declarations needed — the chapter already covers
both halves of the split file (the Rigidity Lemma chain in §1, the Milne §I.3
chain + genus-0 base case + headline in §§2–4). What needs updating:

- The `% archon:covers` line at L3 currently reads
  `% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean AlgebraicJacobian/Genus0BaseObjects.lean`.
  Add `AlgebraicJacobian/RigidityLemma.lean` after the split.

**Main theorem proof strategy**: N/A (pure file-move).

**References for writer**: none (refactor reflection only).

**Subphase choices exposed**: none (single deterministic update).

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `prop:genusZero_curve_iso_P1` (L1572–L1613) + `rmk:genusZero_iso_subbuild`
    (L1615–L1625) is the only incomplete block — currently a 50-line "Mathlib
    gap" disclosure. Per iter-171's reversal (commit to in-tree RR sub-build),
    this must be expanded into the 4-sub-chapter `RRBridgeGenus0_P1.tex`
    proposed above. This is **not** a HARD GATE finding for the iter-171
    `gmScalingP1` prover lane: the RR bridge is downstream of `gmScalingP1` in
    the dependency graph (it feeds `rigidity_genus0_curve_to_grpScheme`, not
    `gmScalingP1` itself). The genus-0 chain through
    `thm:rigidity_genus0_curve_to_AV` is fully complete + correct *modulo*
    this one outstanding gap.
  - The 𝔾ₘ-scaling shortcut prose (rewritten iter-164/165/170) is in good
    shape: `def:gaTranslationP1` carries the iter-170 NOTE on the option-(c)
    decision, `lem:gmScaling_fixes_zero` carries its iter-170 NOTE on the
    gated-on-`gmScalingP1`-body status, the bridge `prop:morphism_P1_to_AV_constant`
    proof at L1469–L1525 is full, and `thm:rigidity_genus0_curve_to_AV` reads
    cleanly as the 1-line composition of the iso-transport with the
    base-case constancy. No notes here.
  - HARD GATE for the iter-171 `Genus0BaseObjects.lean` `gmScalingP1` prover
    lane: **GATE CLEARS**. The chapter is complete + correct for everything
    that feeds `gmScalingP1` (`def:genus0_base_objects`, `def:gm`,
    `def:gm_grpObj`, `def:projlinebar_affine_cover`, `def:proj_chart_ring_iso`,
    `lem:proj_chart_ring_iso_aux_left`, `def:gaTranslationP1`), and the
    iter-170 NOTE blocks correctly record the option-(c) decision. No must-fix
    finding tied to this lane.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Route A per-sub-phase decomposition (L347–L432) is at the right granularity
    to *identify* the work but not at sub-chapter granularity. The four
    sub-phase paragraphs sit *inside* the proof of `thm:nonempty_jacobianWitness`
    as bullets; they carry LOC/iter estimates and Mathlib namespaces but no
    per-sub-phase `\label`, `\lean{...}`, or proof skeleton — i.e., not yet
    prover-ready as 4 parallel-startable lanes per the iter-171 STRATEGY.md
    commitment. The five unstarted-phase proposals above
    (`JacobianRouteA1_RelativeSpec.tex`, `JacobianRouteA1_LineBundlePullback.tex`,
    `JacobianRouteA1_RelPicFunctor.tex`, `JacobianRouteA2_HilbertQuot.tex`,
    `JacobianRouteA3_Pic0.tex`, `JacobianRouteA4_AlbaneseUP.tex`) are the
    sub-chapter expansion this finding requires. Not a HARD GATE issue for the
    iter-171 `gmScalingP1` prover lane (`Jacobian.tex` does not cover
    `Genus0BaseObjects.lean`); soon-severity.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Large fallback-route chapter (2621 LOC) hosting the off-critical-path
    `rigidity_over_kbar` declaration + chart-algebra envelope + the
    iter-145-EXCISED bundled-route history. Hygiene is good: every excised
    declaration's `\lean{...}` hint is *stripped* and the placeholder appears
    only inside `%` comments (verified: `mulRight_globalises_cotangent`,
    `basechange_along_proj_two_inv*`, `omega_free`, `omega_rank_eq_dim`,
    `cotangentSpaceAtIdentity_iso_localRingCotangent`,
    `relativeDifferentialsPresheaf_basechange_along_proj_two` — all 6 are
    comment-only). The corresponding lemma blocks are correctly marked
    `\notready`. No live `\lean{...}` block in this chapter resolves to a
    non-existent declaration. Citation discipline OK
    (Mumford/Hartshorne/Milne files all exist).

## Severity summary

- **must-fix-this-iter**:
  - `unstarted-phase proposal: Route A.1 (RelativeSpec functor) — dispatch
    blueprint-writer for `blueprint/src/chapters/JacobianRouteA1_RelativeSpec.tex`
    or record deferral`
  - `unstarted-phase proposal: Route A.1 (LineBundle pullback) — dispatch
    blueprint-writer for `blueprint/src/chapters/JacobianRouteA1_LineBundlePullback.tex`
    or record deferral`
  - `unstarted-phase proposal: Route A.1 (RelPic functor) — dispatch
    blueprint-writer for `blueprint/src/chapters/JacobianRouteA1_RelPicFunctor.tex`
    or record deferral`
  - `unstarted-phase proposal: Route A.2 (Hilbert/Quot + FGA Pic
    representability) — dispatch blueprint-writer for
    `blueprint/src/chapters/JacobianRouteA2_HilbertQuot.tex` or record
    deferral`
  - `unstarted-phase proposal: Route A.3 (Pic⁰ identity component + degree
    map) — dispatch blueprint-writer for
    `blueprint/src/chapters/JacobianRouteA3_Pic0.tex` or record deferral`
  - `unstarted-phase proposal: Route A.4 (Albanese UP of Pic⁰) — dispatch
    blueprint-writer for `blueprint/src/chapters/JacobianRouteA4_AlbaneseUP.tex`
    or record deferral`
  - `unstarted-phase proposal: genus-0 RR bridge (4 Hartshorne IV.1.3.5
    ingredients) — dispatch blueprint-writer for
    `blueprint/src/chapters/RRBridgeGenus0_P1.tex` or record deferral`
  - `Jacobian.tex` is `complete: partial` (Route A sub-phases under-decomposed
    — see proposals above)
  - `AbelianVarietyRigidity.tex` is `complete: partial` (only the
    `prop:genusZero_curve_iso_P1` block is incomplete, and the
    `RRBridgeGenus0_P1.tex` proposal above is the must-act fix); but this
    chapter's verdict on the **HARD GATE for the `gmScalingP1` prover lane**
    is `complete + correct + no live must-fix-this-iter finding on the
    `gmScalingP1`-feeding sub-tree`, because the RR-bridge gap is downstream
    of `gmScalingP1`, not upstream. The HARD GATE for the iter-171 prover lane
    on `Genus0BaseObjects.lean` therefore **CLEARS**, while the
    chapter-level `complete: partial` verdict triggers a parallel
    blueprint-writer dispatch for the RR sub-build.

- **soon**:
  - `Jacobian.tex` / `\lean{AlgebraicGeometry.positiveGenusWitness}`: the named
    target is well-formed but the chapter does not pin which Route A
    sub-witness lands first; resolved by the A.4 unstarted-phase proposal.
  - `AbelianVarietyRigidity.tex` / `lem:hom_Ga_to_av_trivial` +
    `lem:hom_from_Ga_trivial`: iter-164 NOTE honestly discloses that the Milne
    Prop 3.9 verbatim quotes were reproduced from a prior-session-verified
    in-tree copy rather than re-rendered from the PDF (no `pdftoppm` on host).
    Soon-severity hygiene: a future iter with a PDF renderer should re-verify
    those quotes and the corresponding writer report should explicitly list
    `references/abelian-varieties.pdf` in the References-consulted section.

- **informational**:
  - `Jacobian.tex` references `\cref{thm:GrpObj_eq_of_eqOnOpen}` as the
    handle that closes the dominant-source / separated-target lift; the same
    handle is referenced by `AbelianVarietyRigidity.tex`. Both are correct;
    informational that this is the single point of multi-chapter dependence
    on `Rigidity.tex`.

Overall verdict: blueprint is in good shape for the iter-171 active prover
lane on `Genus0BaseObjects.lean` — the HARD GATE on `AbelianVarietyRigidity.tex`
CLEARS, no must-fix finding obstructs `gmScalingP1`. **7 strategy phases lack
prover-ready blueprint coverage and 7 unstarted-phase proposals are provided
for immediate writer dispatch** (3 for Route A.1, 1 each for A.2/A.3/A.4, and
1 for the RR-bridge in-tree sub-build); a parallel housekeeping update is
proposed for the AVR-split `% archon:covers` annotation. The plan agent
should dispatch a blueprint-writer for each of these proposed chapters this
iter (or record an explicit deferral rationale in `iter/iter-171/plan.md`)
to enable parallel Route A prover lanes from iter-172 onward.

## Notes for Plan Agent

- The seven unstarted-phase proposals share a natural sequencing: A.1.a
  (`RelativeSpec`) is the smallest standalone entry point and the highest-
  parallel-startable; A.4 is the cleanest because every named premise it
  consumes is already proven axiom-clean in tree. If the writer budget is
  limited this iter, recommended dispatch order is **A.1.a, A.4, RR-bridge,
  A.3, A.1.b, A.1.c, A.2** (cheapest infrastructure first, dominant block last).
- The HARD GATE-clearing rationale for the iter-171 `gmScalingP1` prover lane:
  the dependency chain feeding `gmScalingP1` is `def:genus0_base_objects` →
  `def:projlinebar_affine_cover` → `def:proj_chart_ring_iso` →
  `def:gaTranslationP1` (the `\lean{AlgebraicGeometry.gmScalingP1}` target).
  None of these is `\notready`, none has an excised `\lean{}` hint, and the
  iter-170 NOTE blocks correctly record the option-(c) decision. The RR bridge
  is downstream (it feeds `thm:rigidity_genus0_curve_to_AV` via
  `rigidity_genus0_curve_to_grpScheme`), not upstream of `gmScalingP1`. The
  blueprint-level gating signal for the iter-171 prover lane is therefore
  GREEN.
