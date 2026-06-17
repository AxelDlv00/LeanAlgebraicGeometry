# Blueprint-writer directive — RigidityKbar.tex, iter-145

## Iteration

145

## Slug

rigiditykbar-iter145

## Target chapter

`blueprint/src/chapters/RigidityKbar.tex` (1790 LOC currently).

## Strategic context (you write the chapter; this is the rationale)

The iter-144 chart-algebra pivot committed the M2.body-pile route to chart-algebra (piece (ii) PIN-path-(b), inflated to ~600–1050 LOC). The iter-144 writer added a `\paragraph{Iter-144 chart-algebra envelope for piece (ii)}` block at L99–L114 listing 5 sub-pieces as **prose bullets only**, with no first-class declaration blocks and no `\lean{...}` hints. The iter-145 blueprint-reviewer flagged this as MUST-FIX-THIS-ITER: provers cannot scaffold without target names + blocks. This dispatch lands the missing first-class blocks.

Additionally, the iter-145 strategy-critic (Q3) flagged an internal contradiction in the M2.a `df = 0` derivation chain in STRATEGY.md L441–L445 — the chain says both "global-section-vanishing argument on Ω_{C/k} follows from chart-local fact + glueing" AND "Vanishing-of-global-section-of-Ω_{C/k} is NOT invoked". One of these is wrong. The blueprint chapter must articulate the chart-algebra (β) closure path honestly — what `H^0(C, Ω_C) = 0`-equivalent content the chart-algebra (β) helper actually uses, and whether Serre duality is just being un-named or genuinely not invoked.

## Required edits

### Edit 1 (MAIN MUST-FIX) — lift 5 chart-algebra piece (ii) sub-pieces into first-class blocks

In `RigidityKbar.tex`, after the existing `\paragraph{Iter-144 chart-algebra envelope for piece (ii)}` block at L99–L114, insert a new subsection `\subsection{Chart-algebra piece (ii) first-class decomposition}` (or fold it directly into the existing § "Piece (ii)" section as appropriate; you decide layout). The five sub-pieces with their pre-committed Lean target names (the planner pre-commits these; if you find a more idiomatic naming after Mathlib search, surface a NOTE but keep the pre-committed name unless mathematically unsound):

1. **Sub-piece (α)** — `Algebra.IsPushout`-from-affine-product helper. Pre-committed Lean target: `AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product`. Mathematical content: given two affine charts $U_1, U_2$ of schemes $X_1, X_2$ over `Spec k`, the affine pullback $U_1 \times_k U_2$ is the spectrum of the tensor-product algebra, and the ring-level square is an `Algebra.IsPushout` (Mathlib: see `Mathlib.RingTheory.TensorProduct.Basic` + `Algebra.IsPushout`). LOC envelope ~80–150. Should consume `pullbackSpecIso` + `_hom_fst`/`_inv_fst` per Mathlib snapshot. Write a `\begin{lemma}\label{lem:chart_algebra_isPushout_of_affine_product}\lean{AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product}` block with a `\uses{...}` and a 4–8-step proof sketch.

2. **Sub-piece (β-core)** — per-chart translation-invariance Kähler-derivation. Pre-committed Lean target: `AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart`. Mathematical content: for a chart-affine ring map `f^# : Γ(W, O_A) → Γ(V, O_C)` (with $W \subseteq A$ a chart of the identity section's neighbourhood, $V \subseteq C$ an affine chart of $C$), if the chart-Kähler-derivation difference $d(f^# \phi) - f^# d\phi$ vanishes as a derivation $Γ(W, O_A) → Γ(V, O_C)$, then `f^# φ ∈ k·1 ⊆ Γ(V, O_C)` (i.e. `f^#` factors through the base-field inclusion at chart level). This is the **load-bearing β helper**. LOC envelope ~150–300. Write a `\begin{theorem}\label{lem:chart_algebra_df_zero_factors_through_constant_on_chart}\lean{AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart}` block.

   **Honesty requirement (Q3 absorption)**: in the proof sketch, you must address the strategy-critic Q3 contradiction explicitly. Specifically articulate whether the proof:
   - (a) Invokes a 2-chart Čech-style argument computing `H^0(C, Ω_{C/k}^{⊕n}) = 0` directly, which is mathematically equivalent to `H^0(C, Ω_C) = 0` (Serre-duality-named, but the content is the same). If so, name the Čech / Mayer–Vietoris argument used, list its inputs (the project's `Cohomology_MayerVietoris.tex` and `Cohomology_StructureSheafModuleK.tex` chapters supply Mayer–Vietoris infrastructure on schemes; they're already used for `Genus.lean`'s `H^1(C, O_C)` computation, so the analogous use on `Ω_C` is technically available). The disclaimer "without Serre duality" should clarify that **Serre duality is not the named theorem invoked, but the underlying H^0(C, Ω_C) vanishing IS the content**.
   - (b) Genuinely avoids `H^0(C, Ω_C)` vanishing via an alternative chart-local route. If so, articulate this route explicitly — what does the work instead? Layer-1 of STRATEGY.md says "vanishing on `n` cotangent generators + lands in `Γ(V, Ω_{V/k})`" — but that lands a chart-local fact only; passing from chart-local kernel-vanishing to global "the chart-Kähler-derivation extends to a global derivation that vanishes" requires either (i) Čech glueing argument (= H^0 vanishing in disguise), (ii) a pointwise stalk-vanishing argument with no global-cohomology step, or (iii) something else. Name which.
   
   **Recommendation**: option (a) is the honest framing — the chart-algebra (β) helper invokes content equivalent to `H^0(C, Ω_C) = 0` via a chart-Čech computation, NOT Serre duality as a named theorem. This means the project's existing Mayer–Vietoris infrastructure carries the load. Articulate this in the proof sketch. The "Serre duality is NOT invoked" disclaimer should narrow to "the named Serre-duality theorem is not invoked; the cohomological content `H^0(C, Ω_C) = 0` on a genus-0 curve IS invoked via a chart-Čech computation matching the project's `Cohomology_MayerVietoris.tex` idiom".

3. **Sub-piece (β-aux integrally-closed-constants)** — the integrally-closed-constants helper. Pre-committed Lean target: `AlgebraicGeometry.constants_integral_over_base_field`. Mathematical content: in a smooth proper geometrically irreducible scheme $X$ over a base field $k$, the global sections $\Gamma(X, O_X)$ form an integral domain that is integral over $k$, hence (by integral-closedness of the field $k$ — `IsAlgClosed` for `k̄`, OR `Field`-axiom for general $k$ with finite type) equal to $k$. LOC envelope ~50–100. Write a `\begin{lemma}\label{lem:constants_integral_over_base_field}\lean{AlgebraicGeometry.constants_integral_over_base_field}` block.

4. **Sub-piece (β-core ring-side)** — algebra-level core `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`. Pre-committed Lean target (project-namespaced until upstreamed): `AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`. Mathematical content: for a ring-map `A → B` between commutative rings where $A$ is a field, if `D : B → Ω_{B/A}` is the universal derivation and `b ∈ B` satisfies `D b = 0`, then `b ∈ range (algebraMap A B)` — i.e. constants are exactly the kernel of `D`. Standard ring-side Kähler-derivation fact. LOC envelope ~200–350. Write a `\begin{theorem}\label{lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero}\lean{AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero}` block.

5. **Sub-piece (scheme-level lift)** — `Scheme.Over.ext_of_diff_zero`. Pre-committed Lean target: `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero`. Mathematical content: if `f, g : C → A` are two morphisms over `Spec k` (smooth proper geometrically irreducible schemes), `df = dg` (their cotangent pull-backs agree), and `f` and `g` agree on at least one point (chart-restriction), then `f = g`. Packages the chart-algebra chain into `Scheme.Over.ext_of_eqOnOpen` shape. LOC envelope ~100–150. Write a `\begin{theorem}\label{lem:Scheme_Over_ext_of_diff_zero}\lean{AlgebraicGeometry.Scheme.Over.ext_of_diff_zero}` block.

For each block, write the prose proof sketch detailed enough that an iter-146+ prover lane can formalise step-by-step without re-deriving the mathematical content (4–10 steps per block). Reference Mathlib lemma names explicitly with `\texttt{...}`. Tag relevant Mathlib infrastructure status (`[verified]` / `[expected]` / `[gap]`) — the planner has verified the following via the iter-145 M3 audit refresh and earlier consults:
- `Algebra.IsPushout`: [verified] in `Mathlib.RingTheory.IsPushout`.
- `pullbackSpecIso` + `_hom_fst`/`_inv_fst`: [verified] in `Mathlib.AlgebraicGeometry.Pullbacks`.
- `KaehlerDifferential.D` + `KaehlerDifferential.exact_kernel_*`: [verified] in `Mathlib.RingTheory.Kaehler.Basic`.
- `RingHom.iterateFrobenius_comm`: [verified] in `Mathlib.Algebra.CharP.Frobenius` (for the char-p layer of β-core).
- `Algebra.IsStandardSmooth.free_kaehlerDifferential`: [verified] in `Mathlib.RingTheory.Smooth.StandardSmoothCotangent`.
- `Scheme.Over.ext_of_eqOnOpen`: [verified] in project `AlgebraicJacobian/Rigidity.lean`.

### Edit 2 (sync_leanok mis-mark carry-overs — cleanup) — DO NOT add or remove any `\leanok` marker

The blueprint-reviewer flagged stale `\leanok`s at L434, L552, L1669, but **these are deterministic-sync_leanok-phase territory; the writer must NOT touch them**. Skip this edit silently.

### Edit 3 (Step 3 sub-recipe descope NOTE) — augment

If `RigidityKbar.tex` § "Piece (i.b) Step 3 sub-recipe" (around L601–L666) still presents the Step 3 chase as live, add a NOTE that under the iter-144 chart-algebra pivot, the Step 3 chase is descoped from critical path (already present per iter-144 writer L882–L887 inline comment; if missing, surface explicitly). One sentence is sufficient.

## Boundaries

- Do NOT edit `STRATEGY.md` (planner's domain).
- Do NOT edit any `.lean` file.
- Do NOT add or remove `\leanok` markers (deterministic-sync territory).
- Do NOT add or remove `\mathlibok` markers (review-agent territory).
- The `\fst`/`\snd`/`\pr`/`\Scheme`/`\Hom`/`\app`/`\obj` macros are conventionally undefined in `common.tex` and rendered as their literal names; do NOT touch macro definitions.
- Do NOT spawn a reference-retriever (the Mathlib infrastructure list above is already verified by the planner).

## Output

The writer's report at `task_results/blueprint-writer-rigiditykbar-iter145.md`. Iter-145 blueprint-reviewer will not re-dispatch this iter; the iter-146 mandatory blueprint-reviewer confirms the updates.
