# Wave-4 DAT-D — Div^g-lite representability: the binding worksheet (`AJCR.w4-rep.datum.dat-d`)

*Written 2026-07-16 (Fable design agent). Route design per the (C2) lesson: decisions
first, provers only from specs derived from this worksheet. BINDING parent:
`informal/w4-datum-worksheet.md` (§2.1 one-openness-mechanism, §2.2 step 5, §4 DAT-D
row, §5 risks 1/7, Discipline). Models: `informal/w4-rigid-engine-worksheet.md`,
`informal/w4-flv-worksheet.md`, `informal/deg-d5b-worksheet.md`. Inputs read in full:
the landed fibre engine (`RiemannRoch/ChartColength.lean` — SB-3a `:126`, multiplicity
leg `:278`, colength keystone `:411`, finiteness `:377`; `Picard/DivisorClass.lean` —
`LocalEquations` `:112`, `picClass` `:238`, `restrict/mul/rescale` + class laws
`:260,:333,:413`; `Picard/MeromorphicPresentation.lean` — `germGenericUnits` `:58`,
`MeromorphicPresentation` `:123`, `presentation` `:198`), DAT-0a
(`RiemannRoch/UniformVanishing.lean:71`, being landed in parallel — statement FROZEN,
consumed here as the uniform bound `b`), the GRQ route map (`SubProjects/GR-Quot-Closure`:
`PROGRESS.md` — `Grassmannian.represents` sorry-free axiom-clean;
`AlgebraicJacobian/Picard/GrassmannianCells.lean`, `GrassmannianQuot.lean`, anchors
below), Kleiman `references/kleiman-picard-src/kleiman-picard.tex` (`sc:red` 1694–1893:
`df:red` 1728–1731, `lm:ctn` 1733–1816, `df:div` 1823–1835, `th:repDiv` 1837–1866,
`ex:DivC` 1868–1883; `sb:Q` 1897–1935; `th:LinSys` 1963–2030; strata 2249–2306; crux
2341–2358), `informal/w4-cbc-recon.md` §3 (the GREEN/AMBER/RED protocol),
and the kernel-discipline protocol sections of the 07-14/07-14b/07-15 handoffs.
Mathlib claims grep-verified this pass against the pinned checkout
(`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib`, v4.31.0, rev
`fabf563a`), cited `file:line`. No Lean edited; no build run.*

**STATE AT WRITING.** Everything DAT-D's dependency row names is landed or frozen: the
colength dictionary (`finrank_quotient_span_section`, `ChartColength.lean:411`, with the
multiplicity leg `:278` and Dedekind charts `:126`); `LocalEquations` + `picClass` + the
refine/mul/rescale class laws (`DivisorClass.lean`); the meromorphic bridge; DAT-0a's
uniform bound (`exists_bound_subsingleton_hModule_one_of_isFinite_toP1`,
`UniformVanishing.lean:71`, sibling-landing); the rigid engine Level 2 + openness export
(`rigidEngine_isOpen_vanishing`, `RigidEngine4Assembly.lean:441`; `relTwistRigidEngine`,
`RigidEngine4Engine.lean:174`; on-the-nose base change `RigidEngine4BaseChange.lean:471,445`);
FLV class form + rank anchor (`FLVClass.lean:360,412`) and `peel_effective` (`:292`);
the fiber twist (`FiberTwist.lean:301,306`) with the dominance witness
(`Curve/MapToP1.lean:125`). NOT landed: DAT-1 (m-chart constructor), DAT-A, and every
DD-brick below. GRQ's `represents` is green in ITS tree (`GrassmannianQuot.lean:5600`)
— a route map to PORT, never import.

**VERDICT IN ONE LINE.** Div^g-lite is the functor of `LocalEquations`-families carrying
a finite-projective rank-`g` colength certificate, on the picEt affine-opens-limit
vehicle; it embeds into a ported-GRQ **pair** of Grassmannians at the uniform twists
`Θ^M, Θ^{M+s}` (windows from DAT-0a's `b`), and is carved there by a **single
equalizer-gift CLOSED condition** — the two-window multiplication carve
`H_s·K ⊆ K′` — with **no open condition at all** (Div^g is proper; the
one-openness-mechanism discipline is met vacuously), the balloon being honestly
relocated into ONE fibrewise theorem (P-fib, the persistence heart) whose proof route
is designed here through the P-adic lane model but whose endgame (F3) is NOT closed in
this pass and is mandated as the campaign's first probe; fallback: the matrix-chart
(Hilb-of-points) route, in-campaign AMBER; Sym^g stays the orchestrator-only RED.

---

## §1 THE DIVISOR-FUNCTOR PIN (obligation 1)

### 1.1 The family carrier (DECIDED)

Standing Stage-B data: the field `k'` (a finite separable level; Challenge.lean's
baseChange instances `:174–187` make `C' := C_{k'}` a legal curve over `k'`), the pinned
`π : C'.left ⟶ P1 k'` with `[IsFinite π] [IsDominant π]` (`MapToP1.lean:125`),
`F := fiberWeilDivisor π` (zeros of the chart coordinate `u`), `P := (divOf u⁻¹)⁺` (its
poles; `deg F = deg P =: δ ≥ 1` by DAT-0b + `deg_divOf = 0`), `Θ := fiberTwist π 1`
(`FiberTwist.lean:301`), `b :=` the DAT-0a bound. For a `k'`-algebra `R`, the relative
curve is `C_R := (C' ⊗ overSpec k' R).left` (the landed pattern).

> **(D1) A certified divisor family of degree `n` over `R`** is a pair `(d, c)`:
> - `d : (C_R).LocalEquations` (`DivisorClass.lean:112` — pointed cover, regular
>   equations, unit ratios; the landed carrier, `Type u`), together with a
>   **finite chart adaptation**: a finite index `J = J₀ ⊕ J₁`, basic opens
>   `D(h_j) ⊆ V_iᴿ` of the two pinned charts with partition witnesses covering `C_R`,
>   and equations `f_j ∈ Γ(D(h_j))` — exactly the DAT-1 cocycle-datum normalization
>   (parent §3.2) with regular `f_j` instead of units, refining `d` (so
>   `picClass` is unchanged, `picClass_restrict`/`rescale`, `DivisorClass.lean:278,450`);
> - `c` : the **colength certificate**: (c1) each chart-local colength module
>   `Γ(D(h_j))/(f_j)` is a finite projective `R`-module; (c2) the **glued colength
>   module** `W(d) := eq(∏_j Γ(D(h_j))/(f_j) ⇉ ∏_{j,j'} Γ(D(h_j) ⊓ D(h_{j'}))/(f))`
>   is finite projective of constant fibre rank `n` over `R` (rank pinned fibrewise:
>   `finrank κ(p) (W(d) ⊗ κ(p)) = n` at every `p : PrimeSpectrum R` — honest finrank on
>   a finite projective, never `Nonempty`).
>
> `DivFam n R` := the setoid quotient of certified families by **divisor equality**:
> common refinement + unit rescaling of the equations (the `CechPic`-pattern setoid;
> both moves are the landed `restrict`/`rescale` with their class laws). The functor
> value at a general test `T : Over (Spec k')` is the **affine-opens-limit vehicle**
> verbatim from `Picard/PicEt.lean:9–36`: a compatible family of `DivFam n Γ(T.left, U)`
> over `U ∈ T.left.affineOpens` — `Type u`-small by construction.

Why this exact pin:
- **`LocalEquations` is the fibre-engine-ready carrier**: `picClass` (the Abel hook DAT-C
  consumes), `mul` (adding `Σ`), `presentation` → the `ordZ`/colength dictionary. Kleiman's
  `df:red` (tex 1728–1731, "effective divisor + S-flat") is equivalent through `lm:ctn`;
  we pin the equation-side spelling because the tree owns it.
- **The certificate is the flatness** (Kleiman tex 1829–1835: functoriality of `Div` is
  exactly "the ideal is flat, so it pulls back"). Total-space regularity alone does NOT
  bound the family: over `R = k'[x]`, `f = xt − 1` on an affine chart is regular with
  invertible ideal but colength jumping 0/1 — (c1)+(c2) exclude exactly this.
- **(c1) is the flatness datum, (c2) the degree datum.** (c1) makes every Tor-argument
  below fire chart-locally; (c2) is `deg = n` — at a field point the dictionary
  (`finrank_quotient_span_section`, `ChartColength.lean:411`) reads rank `W(d) ⊗ κ(p)`
  as `∑ ord_x · residueDeg`, i.e. the honest fibre degree.
- Equivalent spellings (Kleiman-flatness of the subscheme; an engine-glued `𝒪/I`-sheaf
  with `QcohOn`) are recorded as LEMMAS, not carrier fields (DD-1); the equalizer module
  keeps the carrier module-algebra-only.

The campaign consumes `n := g`; state the carrier for general `n` (free generality;
`ex:DivC` tex 1868–1877 is the classical anchor for the degree components).

### 1.2 Naturality / base change / restriction (DECIDED — the map-action theorems)

- **(DD-1a) certified pullback along `R → R'`** (test maps): apply the landed
  `LocalEquations.pullback` (`Picard/LocalEquationsPullback.lean:118`) along
  `C_{R'} → C_R`; its regularity input `hreg` is discharged FROM THE CERTIFICATE, not
  from flatness of the map (the map is a base change of `Spec R' → Spec R` — not flat):
  from `0 → B →^{f_j} B → B/(f_j) → 0` with `B/(f_j)` **flat** (c1),
  `Tor₁(B/(f_j), R') = 0` keeps the row exact after `⊗_R R'`, so `f_j ⊗ 1` is regular
  section-level; germ-level regularity follows by localization-exactness (stalks are
  localizations of chart rings). Certificates base-change by right-exactness
  ((c1): `(B/(f_j)) ⊗ R'`; (c2): the equalizer commutes with `⊗ R'` **because the
  certified equalizer is a kernel of a map of finite projectives with split-exact
  behaviour** — the RE-3 rigidity pattern, `RigidEngine4BaseChange` mirrors). This is
  Kleiman `lm:ctn` (i)⟹(iii)⟹(i) (tex 1747–1815) made cheap by carrying flatness as
  data — the Tor/Nakayama proof there is 15 lines of module algebra and is the template.
- **(DD-1b) restriction along opens of `T`** (the vehicle's compatibility maps): the
  special case `R → R_{h}`; localization only.
- **(DD-1c) the field-point dictionary**: over a field `K` (standing pack via
  `Curve/BaseChangeInstances`), `DivFam n K ≃ {D : CurveDivisor // 0 ≤ D ∧ deg K D = n}`
  — equations from the tracked point presentations (`PointPresentation`, deg-d5b
  pattern), degree by `ChartColength.lean:411`, injectivity by `ordZ`-reading of the
  equations. This is DAT-B's consumption surface and P-fib's translation layer.

### 1.3 The chart-index `Type u` spelling (parent §5.7, discharged)

- DAT-C/DAT-glue's chart index: `c = (m, Σ)` pinned as the Σ-type
  `(m : ℕ) × {Σ : (C').left.CurveDivisor // 0 ≤ Σ ∧ CurveDivisor.deg k' Σ = d_m − g}` —
  `Type u` since `CurveDivisor : Type u` (`RiemannRoch/Divisor.lean:40`). No cover/cocycle
  data enters the index.
- DAT-D's own internal gluing index (the ported Grassmannian atlas): `Finset (Fin r)` —
  finite (GRQ's index, `GrassmannianCells.lean:1141`).
- The vehicle index: `T.left.affineOpens` — `Type u` (the PicEt precedent).

### 1.4 What the functor pin deliberately does NOT say

No `Hilb`, no subscheme-of-`C_R` carrier (Kleiman `th:repDiv` tex 1837–1866 is the
BYPASSED route — cite it only as context, never port), no sheaf-of-ideals vocabulary in
the carrier, no `𝒪_T`-module sheaves on tests (the vehicle keeps everything in section
rings), no degree via Hilbert polynomials (route rule; `ex:DivC` note), and no
Zariski-sheafification: the vehicle is a limit, and its sheaf property is a THEOREM
(DD-2), mirroring DAT-2.

---

## §2 THE GRASSMANNIAN PORT (obligation 2)

### 2.1 The uniform twists and the fixed windows

Set `δ := classDeg k' Θ ≥ 1` (DAT-0b), `b :=` DAT-0a's bound, `g :=` the genus. Pin two
twist exponents (the **window ledger**, exact arithmetic owned by DD-0):

- `s :=` least with `(s − 1)·δ ≥ b + 2g` (the multiplier step: graded surjectivity
  `H_s ↠` the `P`-level algebra, and the Koszul/pencil windows);
- `M :=` least with `M·δ ≥ b + 2g + (g + 2)·(s + 1)·δ` (embedding window
  `d_M − g ≥ b`, normalization window `d_M − 2g ≥ b`, and every lane window of §3.3
  down to depth `(g+1)` in `P`-steps stays `≥ b`).

`H_A := Sheaf.HModule ((C').left.divisorSheaf k' (A • F)) 0` for `A ∈ {s, M, M+s}` —
fixed finite-dimensional `k'`-spaces with `h¹ = 0` (DAT-0a) and
`r_A := dim H_A = A·δ + 1 − g` (rank anchor, `FLVClass.lean:412`). Over any test `R`,
the engine's base-change clause identifies `H⁰(C_R, glued Θ^A) ≅ H_A ⊗_{k'} R` **on the
nose** (DAT-1(1d) mirror of `RigidEngine4BaseChange.lean:471`). `M` is independent of
the strata exponent `N` of the parent §2.4 — DAT-D fixes its own twists once.

### 2.2 The ported functor: the SMALL submodule spelling (DECIDED)

GRQ's carrier is large (`RankQuotient r d T`: a sheaf `F : T.Modules` + epi + local
freeness, `GrassmannianQuot.lean:2258`, functor `Type 1`-valued `:2341`, with the
`T.Modules` def-diamond as their standing hazard). The port REPLACES the carrier:

> **(D2) The Grassmannian functor of the port**, on affine tests: for a fixed
> finite-dimensional `k'`-space `H` (`r := dim H`) and `0 < g ≤ r`,
> `grFunctor H g R := {K : Submodule R (H ⊗[k'] R) // (H ⊗ R)/K is a finite projective
> R-module of constant fibre rank g}` — a subSET of the submodule lattice, `Type u`,
> **no setoid**: GRQ's `RankQuotient.Rel` (`:2271`, "same kernel") collapses to equality
> of submodules. Map action: `K ↦ Submodule.map (K ⊗ R → H ⊗ R')`-image; the quotient
> stays projective rank `g` by right-exactness. General tests: the same affine-opens
> vehicle as §1.1.

**The `represents` statement to port** (`GrassmannianQuot.lean:5600`):
`(grFunctor H g).RepresentableBy (Gr g H)` in the vehicle/slice form consumed here —
homEquiv between `T ⟶ Gr g H` (in `Over (Spec k')`) and the vehicle value, natural in
`T`. The representing scheme and proof architecture port 1:1:

| GRQ (route map; their tree) | This tree (the port) |
|---|---|
| `affineChart d r I = Spec (MvPolynomial …)` over ℤ (`GrassmannianCells.lean:56`) | same charts over `k'`, index `I : Finset (Fin r)`, `I.card = g`-complements |
| minor/Cramer transition + `cocycleCondition` (`:245,:604`) | verbatim re-derivation over `k'` |
| `theGlueData : Scheme.GlueData`, `scheme` (`:1141,:1157`) | mathlib `AlgebraicGeometry.Scheme.GlueData` (`Mathlib/AlgebraicGeometry/Gluing.lean:91`, verified) over `k'`; structure map to `Spec k'` from the charts |
| separatedness via `diagonalRingMap_surjective` (`:1231`) | same affine-diagonal argument |
| `RankQuotient`/`Rel`/`rqSetoid` (`GrassmannianQuot.lean:2258–2292`) | **dissolved** into the submodule spelling (D2) |
| `universalQuotient`, `tautologicalQuotient` (`:1835,:2229`), `isLocallyFreeOfRank` (`:2432`) | the universal corank-`g` summand of `H ⊗ Γ(chart)` over each chart, glued by the SAME GL-cocycle |
| `isoLocus`/`chartLocus`/`chartLocus_isOpenCover` (`:2545,:2582,:2680`) | the `I`-frame unit-determinant loci — basic opens of the test ring (see the §3.5 mechanism audit) |
| `grPointOfRankQuotient` + two inverse laws (`:4984,:5024–5588`) | the same Nitsure-§1 chart-by-chart inverse on submodule data |
| their SNAP/graded lane (`SectionGradedRing.lean`, `Γ_*(X,L)`, Gmodule) | **NOT PORTED** — it fed their χ-blocked Quot deferrals; its role (the ambient linear algebra of sections) is played by the engine `H⁰` spaces `H_A` of §2.1 |
| `T.Modules` def-diamond discipline (their PROGRESS notes) | moot — no sheaf-of-modules carrier anywhere in the port |

The GRQ tree proves this architecture closes sorry-free (their `represents` is
axiom-clean); the port re-derives it in smaller vocabulary. Estimated a genuine L→XL
but **mechanical**: every hard step has a green model to imitate.

### 2.3 The embedding of the divisor functor (obligation 2, second half)

For a certified family `(d, c) ∈ DivFam g R`:

1. `𝒪(Θ^M − d)` := the DAT-1 glued sheaf of the cocycle `(fiberCocycle π M)·(ratio
   units of d)⁻¹` on the common refinement — the sheaf-level `mul` of the twist and the
   inverse divisor (class law: `picClass_mul`, `DivisorClass.lean:358`).
2. The section sequence `0 → H⁰(𝒪(Θ^M − d)) → H⁰(𝒪(Θ^M)) → W(d)^{Θ^M} → 0` is exact
   with `W(d)^{Θ^M}` the Θ-twisted colength module (≅ `W(d)` chart-locally; rank `g` by
   (c2)): exactness on the right is the engine fired at fibre degree `d_M − g ≥ b`
   (DAT-0a — **this is where the uniform twist is spent**), through DAT-1's `H⁰`/`H¹`
   clauses and the certificate.
3. **The embedding** `ε : DivFam g R → grFunctor H_M g R × grFunctor H_{M+s} g R`,
   `(d, c) ↦ (K_M(d), K_{M+s}(d))` with `K_A(d) := image of H⁰(𝒪(Θ^A − d)) in H_A ⊗ R`
   (the on-the-nose identification of §2.1). Corank-`g`-summand-ness is step 2.
   Naturality in `R` is the engine's universal base-change clause.
4. **Mono-ness**: `d` is recovered from `K_M(d)` — fibrewise the base divisor of the
   window (`ordZ` reading, DD-1c dictionary), relatively by §3.4. Setoid-invariance:
   rescaling/refinement do not move `K_A` (same subsheaf, `picClass_rescale`-level).

This is Kleiman's `eq:Q`/`th:LinSys` bookkeeping (tex 1979–1998) with `Q = H⁰` (rigid
worksheet §1.1 scope decision) and with `ℙ(Q)` replaced by the Grassmannian pair — no
`f_*`, no `ℙ(Q)` scheme, no EGA II 4.2.3.

---

## §3 THE BALLOON — THE LOCALLY-CLOSED CARVING (obligation 3, DECIDED)

### 3.1 The decision

> **(D3) The two-window multiplication carve.** Inside the ported product
> `Gr := Gr(g, H_M) ×_{k'} Gr(g, H_{M+s})`, the divisor functor is the subfunctor cut
> by the SINGLE closed condition
>
> `(♦)  the composite  H_s ⊗_{k'} K ⟶ H_{M+s} ⊗ R ⟶ (H_{M+s} ⊗ R)/K′  vanishes`
>
> (`H_s ⊗ K → H_{M+s} ⊗ R` = the multiplication map `μ ⊗ R` restricted to `K`), i.e.
> `Div^g ≅ Z(♦) ⊆ Gr` as a CLOSED subscheme. There is **no open condition in the
> carve**: `Div^g` of a proper smooth curve is proper over `k'`, and the design realizes
> this literally. Locally-closed-ness of the parent's mandate is delivered as
> closed-in-`Gr` (a fortiori locally closed).

The condition `(♦)` is one vanishing-of-a-map condition between finite projective
modules — the **equalizer/closed-immersion gift shape**: over a chart ring `R` of `Gr`,
`{R → R' : (♦) ⊗ R' holds}` is represented by `Spec (R/I_♦)` with `I_♦` the entries
ideal (embed the target in a finite free module — projective — and take coordinate
entries on generators of `H_s ⊗ K`); the closed immersion is
`IsClosedImmersion.spec_of_surjective` (mathlib
`AlgebraicGeometry/Morphisms/ClosedImmersion.lean:99`, verified; the `Spec(R/I) → Spec R`
instance at `:113–115`). Globalization over the glued `Gr` by uniqueness of the
universal property on the frame atlas. The Over-form equalizer gift
`isClosedImmersion_equalizer_ι_left` (mathlib `AlgebraicGeometry/Morphisms/Separated.lean:273`,
verified) is the categorical fallback spelling if the entries-ideal route fights;
DAT-C's canonical-section normalization consumes the same gift (parent §2.2.3b).

### 3.2 The fibrewise heart (P-fib) — statement, and honest status

> **(P-fib)** Over any field `K ⊇ k'` (standing pack via `BaseChangeInstances`), let
> `K_M ⊆ H_M ⊗ K`, `K' ⊆ H_{M+s} ⊗ K` be subspaces of codimension exactly `g` with
> `μ(H_s ⊗ K_M) ⊆ K'`. Then there is a UNIQUE effective divisor `D` with
> `deg K D = g`, `K_M = H⁰(𝒪(MF − D))`, and `K' = H⁰(𝒪((M+s)F − D))`.

⟸ is §2.3. ⟹ is THE mountain — this is the honest content behind the parent's
"colength bookkeeping" slogan, and it is a genuine persistence theorem (the
constant-Hilbert-polynomial/Gotzmann-number-`g` instance, curve-specialized). **Status:
proof route designed to lane level (§3.3); the endgame F3 was NOT closed in this
design pass.** The route below is curve-specific and uses only tree-native tools; no
step needs machinery the route banned. The staged-probe mandate (§5) makes F3 the
campaign's first deliverable, before any relative work is committed.

### 3.3 The designed route for P-fib (F1–F4)

All windows below have degree `≥ b` by the §2.1 ledger, so their `h¹` vanish (DAT-0a)
and dimensions are exact (rank anchor). Write `V_j := H⁰(𝒪(MF − D − j·P))`,
`W_j := H⁰(𝒪((M+s)F − D − j·P))` (the **`P`-adic lanes**; `P` = the pole fibre, §1.1).

- **F1 (normalization; window ledger).** `D := bd(K_M)` — the base divisor, from
  pointwise `ordZ`-minima of the window (finitely many conditions; supports finite by
  `ordZ_support_finite`). Additivity `bd(v·φ) = bd(v) + bd(φ)` is elementary `ord`
  calculus. Bounds: `ℓ := deg D ≤ 2g` from the NEW section bound
  `h⁰(𝒪(A)) ≤ deg A + 1` (DD-0: peeling induction on the landed slice SES,
  `ChiSlice.lean:112` machinery + "nonzero section ⟹ effective witness ⟹ deg ≥ 0");
  then `ℓ ≤ g` from `r_M − g = dim K_M ≤ h⁰(MF − D) = r_M − ℓ` (window). Also
  `bd(H_s) = 0`: the sections `1` and `u^{-s}` of `𝒪(sF)` have disjoint zero divisors
  `sF` and `sP` (`u` has no common zeros/poles) — the FLV-0 `ord` table.
- **F2 (the lane model).** For `0 ≤ i ≤ s`, `u^{-i} ∈ H_s` (zeros `iP + (s−i)F ≥ 0`).
  Multiplication by `1` and by `u^{-1}`-steps induce, on lane graded pieces,
  ISOMORPHISMS `gr_j V ≅ gr_j W` and `gr_j V ≅ gr_{j+1} W` (checked this pass: the
  ord-calculus is clean because `F` and `P` have disjoint supports — e.g.
  `1·φ ∈ W_{j+1} ⟺ φ ∈ V_{j+1}` pointwise at `P` and automatic at `F`). Each
  `gr_j V` is a FREE RANK-1 module over the Artinian `k'`-algebra
  `A_P := Γ(𝒪_P)` (`dim A_P = δ`; window surjectivity of the restriction), whose
  ideals are exactly the effective subdivisors `E ≤ P` — **the colength dictionary at
  the lane level** (`ChartColength` legs at the points of `P`). The two-element Koszul
  (pencil trick with `{1, u^{-s}}`, cokernel killed by a window `h¹`) gives the
  reconstruction identity `V = V_P + u·V_P`-form used to kill naive counterexamples.
- **F3 (the rigidity endgame — THE open step).** The image of `H_s` in the lane-0
  operators is ALL of `A_P` (window `(s−1)δ ≥ b + 2g`). Hence `(♦)` forces each lane
  `gr_j K_M ⊆ gr_j V` to be an `A_P`-SUBMODULE — i.e. of divisor form
  `gr_j K_M = (E_j ≤ P)`-conditions — and the shift maps force the profile `(E_j)_j`
  monotone. What remains: the finite bookkeeping induction that a monotone divisorial
  lane profile with total defect `c := g − ℓ > 0` either enlarges `bd(K_M)` beyond `D`
  (contradiction with F1's definition of `D`) or overflows `K'`'s corank budget `g`.
  This is Macaulay-type combinatorics linearized by the lanes; bounded (`≤ g + 1`
  lanes matter), but NOT verified this pass. **F3 is the single honest unknown of the
  whole DAT-D design.**
- **F4 (uniqueness + `K'`-fullness).** Once `c = 0`: `K_M = H⁰(MF − D)` with
  `deg D = g`; the pencil-Koszul surjectivity gives
  `span(H_s·K_M) = H⁰((M+s)F − D)`, of corank exactly `g`, so `K' =` it (both corank
  `g`, one contains the other). `D` is unique (it is `bd(K_M)`). Cheap given F1–F2.

### 3.4 The relative endgame (DD-R) — from the closed locus to the universal family

Over the closed subscheme `Z := Z(♦)` (chart ring `R`, Noetherian — finite type over
`k'`; the engine's Noetherian clause is licensed, rigid worksheet §2.4):

1. **Local generators.** At a point `(p, x)` of `C_R ×_{Z}`-fibre, choose `φ ∈ K_M`
   with fibrewise minimal `ord_x` (= the `D_p`-coefficient, P-fib at `κ(p)`); `φ`
   generates the subsheaf `K_M·𝒪 ⊆ 𝒪(Θ^M)` fibrewise at `x`, hence in a neighbourhood
   by Nakayama — this is Kleiman `lm:ctn` (ii)⟹(iii) (tex 1771–1784) verbatim, run on
   the chart rings; DAT-A2's germ-regularity bridge (fibrewise-regular + flat ⟹
   regular, the (iii)⟹(i) Tor argument tex 1786–1815) upgrades it to a
   `LocalEquations` datum.
2. **The certificate for free.** The colength module of the constructed family is
   `(H_{M+s} ⊗ R)/K'` up to the twist bookkeeping — ALREADY finite projective of rank
   `g` by the ambient normalization (the flag's second window exists precisely to make
   the certificate a projection of the carrier, killing the flattening problem: no
   fibre-dimension semicontinuity, no Fitting ideals — flatness is inherited from the
   Grassmannian, the same mechanism as Grothendieck's graded-locally-free trick, one
   window sufficing on a curve).
3. **The two inverse laws** (`ε ∘ recover = id`, `recover ∘ ε = id`): the GRQ
   inverse-law pattern (`grPointOfRankQuotient` architecture) on the vehicle; mono-ness
   of §2.3.4 plus P-fib's uniqueness clause.
4. Output: `divRep : (divFunctor g).RepresentableBy (DivScheme g)` with
   `DivScheme g := Z(♦)` and the universal certified family over it.

### 3.5 The one-openness-mechanism audit (parent discipline (2))

- The carve has **zero open conditions** — nothing to audit on the moduli side; the
  parent's mandate ("every open is an H¹-fibrewise-vanishing locus") is satisfied
  vacuously, and every open DAT-C later cuts on `DivScheme` (the `V`-charts) is the
  engine export `rigidEngine_isOpen_vanishing` (`RigidEngine4Assembly.lean:441`) on the
  universal family at χ-normalized degree `g` — the single mechanism, as mandated.
- The ported Grassmannian's INTERNAL atlas uses unit-determinant frame loci
  (GRQ `isoLocus`/`chartLocus_isOpenCover`) — basic opens of chart rings. RULING
  (recorded for the orchestrator): these are chart PLUMBING of the sanctioned port
  (parent §4 DAT-D row explicitly orders the GRQ chart/GL_d architecture ported), on a
  par with DAT-1's trivializing basic-open covers (parent §3.2) — they define no
  moduli-theoretic subfunctor and are not an openness mechanism in the sense of the
  discipline. A second MECHANISM would be: semicontinuity loci, Fitting-ideal opens,
  rank-jump loci — none appears anywhere in this design.

### 3.6 Carving spellings weighed and rejected (obligation: at least two, with costs)

- **(a) Pencil-only carve** (conditions `1·K ⊆ K'` and `u^{-s}·K ⊆ K'` only).
  REJECTED — **provably wrong**: counterexample class found this pass. For any
  eigenvalue `μ`, the map `λ ↦ (λ∘u − μ·λ)|_{V_P}` from `(H⁰(MF − D))^*` to a space
  smaller by `δ` has nonzero kernel; a kernel functional `λ` that is not a point
  evaluation (dimension count for `δ ≥ 2`) gives `K := ker λ` of codimension 1 with
  aligned `u`-action, whose pencil span has corank `≥ g` without `K` being of divisor
  form. Full `H_s` kills exactly these (F3's `A_P`-rigidity: simultaneous
  eigenfunctionals of the full multiplication algebra are point evaluations). Recorded
  so no prover "simplifies" `(♦)` to the pencil.
- **(b) Single-Grassmannian determinantal carve** (rank conditions via exterior
  powers: `Λ^{r_{M+s}−g+1}(μ|_K) = 0` closed, `Λ^{…}` nonvanishing open). REJECTED:
  (i) the open half is a rank-jump locus — a second openness mechanism, a design
  regression by the parent's own definition; (ii) mathlib's `LinearAlgebra/ExteriorPower/`
  carries NO base-change kit (grep-verified this pass: no `baseChange` in
  `Basic/Basis/Pairing.lean`) — the functorial closed condition would need a hand-rolled
  `Λ`-base-change campaign. The flag spelling replaces both halves by one vanishing map.
- **(c) Fitting/flattening carve** (carve `{colength sheaf locally free of rank g}`
  by Fitting ideals / flattening stratification). REJECTED: this is literally the old
  D3′'s machinery, named and banned by the parent (§5 risk 1: "colength bookkeeping …
  NOT Hilbert polynomials/flattening"); Fitting-openness is a second mechanism; and the
  relative theory is a mathlib desert.
- **(d) The matrix-chart (Hilb-of-points) route** — NOT rejected: **the designed
  in-campaign fallback** (§5, DD-Φ). Represent `Div^g` directly by gluing
  `{families supported in an affine V}`-loci; each is a cyclic-module/matrix moduli on
  the Dedekind chart (`B → End(W)`, `W` rank-`g` projective, cyclic vector; frame
  charts + GL-cocycle = the same GRQ architecture shape; cyclicity kills automorphisms,
  so no GIT). Costs, honestly: a NEW pre-brick "punctured charts" (every finite set of
  closed points lies in an affine open — buildable from `h0_nsmul_point_unbounded` +
  the MapToP1 finiteness pattern, M); support-avoidance opens `{supp D_t ⊆ V}`
  (complement of the image of a closed set under a proper map — an openness mechanism
  OUTSIDE the licensed one, would need its own ruling); the quasi-projectivity/Gr
  certificate is NOT produced by this route and would need §2.3's embedding anyway or
  a separate affineness argument for `Hilb^g(chart)`. Trigger: F3 walls (§5 probe
  gate). This is the AMBER of the cbc-recon §3 pattern — bounded, known-provable
  mathematics (elementary linear algebra hearts), not open research.
- **(e) Sym^g / Weil symmetric products** — plan-B, the cbc-recon §3 **RED** protocol:
  recorded, NOT invoked, and per the parent §2.5(b) invokable **only by orchestrator
  decision**. Nothing in this pass moved toward RED: the primary and fallback (d) both
  have finite designed frontiers.

---

## §4 THE QUASI-PROJECTIVITY CERTIFICATE AND THE CONSUMPTION MAP (obligation 4)

### 4.1 The certificate shape (DECIDED)

`DivScheme g` is delivered with the bundle:

```
divQProj : IsClosedImmersion (ι : DivScheme g ⟶ GrPair)      -- §3.1, closed in the pair
         × (the GrPair data: finite affine frame atlas, separated, finite type over k')
```

- **Quasi-compactness is free**: the ported `Gr` glues FINITELY many affine charts
  (`Finset (Fin r)` index), so `GrPair` is qc, and a closed subscheme of qc is qc — no
  a-posteriori image argument needed (contrast DAT-J's `J`-qc route, which stands).
- **lft**: charts are `Spec` of finite-type `k'`-algebras; closed immersions preserve.
- **Separatedness**: the GRQ affine-diagonal argument ported (`diagonalRingMap_surjective`
  pattern); closed immersions into separated are separated.
- Honest boundary (recorded): PROJECTIVITY of `Gr` (Plücker) is NOT delivered — GRQ
  itself flags Plücker as under-delivered ("weak skeleton" note, PROGRESS.md). Nothing
  in the parent's Stage B/C/D consumes projectivity; "quasi-projective" is consumed as
  the bundle above. If DAT-G's orbit-in-affine (parent §5 risk 4) turns out to need
  honest ample-bundle quasi-projectivity, the Plücker port is a NEW L-brick to be
  negotiated by DAT-G's worksheet — flagged there, not silently absorbed here.

### 4.2 What the consumers take (binding rows)

| DAT-D deliverable | Consumer and use |
|---|---|
| `DivScheme g` + universal certified family + `divRep` | **DAT-C**: the chart scheme — `V :=` the `h¹`-fibrewise-vanishing open of the universal family's `λθ`-shifted glued sheaf, cut by `rigidEngine_isOpen_vanishing` on the affine atlas (the ONE mechanism); the canonical-section normalization on `V` (invertible `H⁰` + DAT-A) |
| `divRep.homEquiv` naturality + DD-1a | **DAT-C**: the chart functors' open-fibre-product certificates (01JJ `hf` shape) — a test map `T → DivScheme` pulls the universal family; `V ×_{Div} T` is the same engine-open in `T` |
| `LocalEquations.picClass` of the universal family | **DAT-C**: the Abel map `DivScheme → pic^{d}`-layer data (with DAT-4/DAT-5 degree bookkeeping) |
| DD-1c field dictionary + `divRep` at field tests | **DAT-B**: coverage (a degree-`g` class with `h⁰ ≥ 1` has an effective witness = a `DivScheme`-point; `riemann_inequality` + DAT-P) and injectivity bookkeeping |
| `divQProj` bundle (§4.1) | **DAT-glue**: the lft certificate of the 01JJ chart family; **Wave-5** properness inputs (qc); **DAT-G**: quasi-projective charts for orbit-in-affine (with the §4.1 boundary note) |
| the window ledger constants (`b`, `s`, `M`) | **DAT-C/DAT-B**: strata twists must not collide with DAT-D's `M` — they don't (independent exponents; parent §2.4's `N` unconstrained by this worksheet) |
| the §3.5 mechanism ruling | **orchestrator**: echo on the roadmap; binding on Stage-B specs |

---

## §5 SUB-BRICKS — sizes, delegability, order, staged fallbacks (obligation 5)

Sizes per recon convention (S ≤ ~150 lines, M ~150–350, L ~350–500, XL = own campaign).
Kernel discipline per §"Discipline". Parent dependency row honoured: DAT-D consumes
DAT-0a (landed/frozen), DAT-1 (1a/1d clauses), DAT-A(2), ChartColength (landed).

- **DD-0 [S→M, Opus, deps: none — launchable NOW].** The section bound
  `h⁰(𝒪(A)) ≤ max 0 (deg A + 1)` (peeling on the landed slice SES; base case via
  effective-witness degree ≥ 0) + **the window ledger**: named constants `s`, `M`
  (§2.1) and one lemma per window (`h¹ = 0` at every lane/depth used in §3.3), all
  through DAT-0a. Every later brick imports windows ONLY through the ledger names.
- **DD-1 [M→L, Opus from a tight Fable spec, deps: DAT-1(1a) vocabulary].** The functor
  pin of §1: the certified-family structure, the setoid, DD-1a certified pullback
  (Tor/localization), DD-1b restrictions, the finite-adaptation extraction, the vehicle
  assembly, DD-1c field dictionary. The `lm:ctn`-lite Tor lemmas are shared with DAT-A2
  — coordinate with that spec (one home, `Picard/` layer).
- **DD-2 [M, Opus, deps: DD-1].** Zariski sheaf property of `divFunctor` (separation
  from equation rigidity + certificate locality; gluing over basic-open covers; the
  DAT-2 pattern).
- **DD-3 [L→XL staged, Opus provers from a Fable port-spec, deps: NONE — launchable
  NOW, parallel to everything].** The Grassmannian port (§2.2): (3a) charts/cocycle/
  GlueData/scheme over `k'`; (3b) the small functor + map action + vehicle; (3c)
  `represents` via the inverse-law architecture; (3d) separatedness + frame-atlas
  exports; (3e) the universal vanishing-locus closed-subscheme gift (entries ideal +
  `spec_of_surjective`) and the product `GrPair`. **Staged fallback**: (3a)+(3b)+(3e)
  suffice for DD-5/DD-R statements; (3c) can trail (the campaign needs `Gr`'s
  representability only through the inverse laws of `DivScheme` itself — re-audit at
  spec time whether (3c) full strength is consumed or only its chart lemmas).
- **DD-4 [M, Opus, deps: DD-0, DD-1, DAT-1(1d)].** The multiplication data and the
  embedding `ε` (§2.3): `H_A` spaces, `μ` maps (ord calculus), the exact section
  sequence via the engine + certificate, corank-`g` certificates, mono-ness at field
  level, naturality.
- **DD-F [XL — THE HEART, FABLE holds the pen; deps: DD-0, DD-4 field-level only].**
  P-fib (§3.2–3.3), staged **F1 [M] → F2 [M→L] → F3 [L, the open endgame] → F4 [S→M]**.
  **PROBE GATE (binding):** DD-F is entirely field-level (no relative anything) and
  MUST be the first deep brick attempted; if F3 is not closed after two honest Fable
  sessions, STOP, report per the cbc-recon §3 pattern (GREEN = F3 closed; AMBER =
  switch to DD-Φ fallback, orchestrator informed; RED = both hearts walled — plan-B
  Sym^g decision escalated to the orchestrator, never taken locally).
- **DD-R [L→XL, Fable spec + Opus, deps: DD-F, DD-3(3a,3b,3e), DD-1, DAT-A2].** The
  relative endgame (§3.4): `Z(♦)`, local generators, the certificate transport, the
  inverse laws, `divRep`.
- **DD-Q [S→M, Opus, deps: DD-3(3d), DD-R].** The `divQProj` bundle (§4.1) + the §4.2
  export lemmas + blueprint nodes for the campaign (house rule; anchor P-fib on
  Kleiman `th:LinSys`/`sb:Q` ONLY where genuinely matching — the persistence heart has
  NO Kleiman anchor and is anchored as-is, with `ex:DivC` for the degree components).
- **DD-Φ [reserve — the fallback, NOT built speculatively].** The matrix-chart route
  (§3.6(d)): punctured-charts pre-brick [M], cyclic/frame moduli on a Dedekind chart
  [L], support-avoidance opens + gluing [M→L], embedding for the certificate [M].
  Specced at recon level only; opened by the DD-F probe gate verdict AMBER.

**Launch order.**
`{DD-0 ∥ DD-1 ∥ DD-3} → {DD-2, DD-4} → DD-F (probe gate) → DD-R → DD-Q`,
with DD-3 running in its own lane throughout (no dependency on the divisor lane until
DD-R). First launches for the orchestrator: **DD-0, DD-3(3a), DD-1's spec, and DD-F/F1
prep** — DD-F's F1–F2 can start as soon as DD-0's ledger exists, since they are pure
field-level `ord`/window calculus on landed API.

---

## §6 HONEST RISKS — with mitigations (obligation 6)

1. **⚠⚠ F3 (the lane-rigidity endgame) is the campaign's single open mathematical
   step** — the persistence heart behind every Gr-carve in the literature; the parent's
   "colength bookkeeping" slogan under-sold it and this worksheet re-prices it
   honestly. Mitigations: the probe gate (§5 DD-F) makes it the FIRST spend, at
   field level, before any relative or port-heavy work depends on it; the lane model
   (F2) is the tree's own two-lattice geometry (FLV's exhaustion structure), all its
   sub-steps checked this pass; the fallback DD-Φ is designed and elementary; RED
   (Sym^g) exists and is orchestrator-owned. The pencil counterexample (§3.6(a)) is
   recorded so the probe attacks the RIGHT statement.
2. **⚠ DD-R's local-generator extraction over nonreduced chart rings** — the honest
   residue of the flattening problem (fibre-length constancy alone does NOT give
   flatness over nonreduced bases; the design dodges it by inheriting flatness from
   the ambient summand, §3.4.2, but the LocalEquations assembly still walks
   Nakayama/Tor at chart level). Mitigation: it is `lm:ctn`'s 15-line module algebra
   (tex 1771–1815) with the certificate as input; DAT-A2 shares the lemmas.
3. **⚠ Port weight (DD-3).** GRQ's `represents` cone is ~7k lines in their tree.
   Mitigations: the submodule spelling deletes their two worst surfaces (the
   `RankQuotient` setoid and the `T.Modules` def-diamond — their own top hazard note);
   their green tree is a line-by-line route map; internal staging (3a–3e) with (3c)
   trailing.
4. **Certificate spelling friction** (equalizer modules over indexed basic opens;
   submodule-of-tensor towers) — the FLV §5.2-class hazard. Mitigation: opaque defs +
   named bridge lemmas ONCE (house pattern), and DD-1's spec must include a
   half-session elaboration probe before freezing the structure fields.
5. **Window-ledger arithmetic** (off-by-`g`/`δ` errors would silently break F2's
   isomorphisms). Mitigation: DD-0 centralizes every constant and window lemma; no
   downstream file states a numeric window.
6. **Mathlib gifts verified vs assumed.** Verified this pass:
   `Functor.RepresentableBy` (`CategoryTheory/Yoneda.lean:284`),
   `isClosedImmersion_equalizer_ι_left` (`AlgebraicGeometry/Morphisms/Separated.lean:273`),
   `LocalRepresentability.representableBy`/`isRepresentable`
   (`AlgebraicGeometry/Sites/Representability.lean:192,:207`),
   `IsClosedImmersion.spec_of_surjective` (`…/Morphisms/ClosedImmersion.lean:99`),
   `Module.Flat.projective_of_finitePresentation`
   (`RingTheory/Flat/EquationalCriterion.lean:288`),
   `Scheme.GlueData` (`AlgebraicGeometry/Gluing.lean:91`); NEGATIVE result recorded:
   no exterior-power base change in mathlib (§3.6(b)). Assumed at S-fallback size: the
   entries-ideal universal property (hand-rolled, S), product-of-glued-schemes
   plumbing over `k'` (mathlib pullbacks, S–M).
7. **DAT-0a is sibling-landing.** Its statement is read and frozen
   (`UniformVanishing.lean:71`); if its final form shifts (e.g. hypothesis packaging),
   only DD-0's ledger consumes it — one file to patch.
8. **Deliberately NOT decided here** (owned by named specs): the exact Lean spelling of
   the certificate fields and of `grFunctor`'s subtype (lane-owned after the DD-1/DD-3
   probes); whether DD-3(3c) ports full `represents` or only its chart lemmas (spec-time
   audit, §5); the blueprint chapter layout (DD-Q); DAT-G's possible Plücker demand
   (§4.1 boundary — DAT-G's worksheet must read it).

## Discipline (inherited, binding on every DD-brick)

All standing kernel/elaboration rules (handoffs 07-14/14b/15: explicit binders,
opaque-insertion, doc-comments after `set_option … in`, no local-notation binders in
`variable`, term-mode across `restrictScalars`/`Units.map` seams; parallel provers with
the lake mutex `/tmp/claude-1001/ajcr-locks/lake.lock`, disjoint file scopes,
re-read-and-reapply for the root import list; files ≤ 500 lines; `lean_verify` on
keystones; axioms exactly `[propext, Classical.choice, Quot.sound]`; no sorried
instances; roadmap actualized at every milestone, math-first titles). Parent campaign
rules (worksheet §Discipline) apply verbatim; DAT-D-specific additions: (1) every
window fact routes through DD-0's ledger names — a numeric degree bound appearing
downstream is a spec violation; (2) every openness claim in or on `DivScheme` names the
glued sheaf whose `H¹`-vanishing locus it is (there are NONE inside DAT-D proper; the
first is DAT-C's `V`); (3) the carve is `(♦)` exactly — any prover reaching for a rank
condition, a Fitting ideal, or the pencil-only weakening has left the route: stop and
restate; (4) P-fib work is field-level module algebra — a scheme appearing in F1–F4 is
the D1-lesson signal to stop; (5) the GRQ tree is read-only route map: port statements
and architecture, never copy proofs blind, never import.

---

## ADDENDUM (2026-07-16, same day, post-landing sweep) — sibling spellings now pinned

Two Stage-0 siblings landed after this worksheet's main pass; their spellings are now
BINDING consumption points for the DD-bricks (replacing the generic "DAT-0b"/"DAT-5"
references above):

- **DAT-0b = `RiemannRoch/ThetaDegree.lean`**: `classDeg_fiberTwist_one` (`:142`),
  `zero_lt_classDeg_fiberTwist_one` (`:150`), `one_le_classDeg_fiberTwist_one` (`:158`)
  — DD-0's ledger constant `δ` and its positivity come from HERE, no re-derivation;
  `fiberTwist_one_eq_picClass_fiberWeilDivisor` (`:132`) is the Θ-class ↔ `picClass F`
  identification DD-4 uses to state the `H_A` spaces on `divisorSheaf (A • F)` while the
  engine works on the twist cocycle (the W6-lite transport seam); the base-field leg
  (`:180`) is DAT-B/G territory, not DAT-D's.
- **DAT-5 = `Picard/ThetaShift.lean`**: the natural family `thetaFamily` (`:104`,
  naturality `:111`), `degAt_thetaFamily(_pow)` (`:136,:149`), and the Type-valued
  degree layer `picDegLayer`/`picDegLayerFunctor` (`:162,:170` — the parent §5.6 coset
  discipline honoured). The §4.2 Abel-map consumption row is hereby sharpened: DAT-C's
  chart functors out of `DivScheme g` land in `picDegLayerFunctor d` via
  `LocalEquations.picClass` of the universal family; DAT-D exports the class datum,
  DAT-C composes with the DAT-5 shift.

*End of worksheet. Deliverable of record for the DAT-D WORKSHEET-FIRST mandate (parent
§4 DAT-D, §5 risks 1/7); BINDING for the DD-brick specs; Stage B may start proving.
The §3.5 mechanism ruling, the §3.6(a) counterexample, the DD-F probe gate, and the
§4.1 Plücker boundary are to be echoed on the roadmap by the orchestrator; the DD-Φ
reserve and the RED protocol remain orchestrator-decision-only.*
