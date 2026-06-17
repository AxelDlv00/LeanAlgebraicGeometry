# Blueprint Writer Directive

## Slug
rigiditykbar-piecei-realign-iter132

## Target chapter
`blueprint/src/chapters/RigidityKbar.tex`

## Strategy context

This chapter's § Piece (i) prose was last touched by the iter-130 writer
`rigiditykbar-piecei-realign-iter130` (re-aligning from iter-129
(A)-flavoured framing to Replacement (B) chart-base-change framing).
The iter-131 plan agent deferred a further writer pass to iter-132
because the iter-131 refactor lane changed the Lean body shape on
`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` (from `by`-tactic
`Classical.choice (Nonempty.intro X)` to a pure-term `noncomputable def`
using a `Classical.choose`-chain pattern) and the prose needed a single
coherent re-alignment pass after the refactor lands.

The iter-131 blueprint-reviewer flagged the following loci as carrying
iter-128/iter-130-era prose drift:

1. **`lem:GrpObj_cotangent_bridge` proof Step 1 (~line 151)** — describes
   the iter-128 "evaluate-then-extend-scalars" body and Step 1 of the
   bridge proof. Under Replacement (B) (the iter-130+/-131 body), the
   body is NOT "extend scalars of `(Ω_{G/k})(G)` along
   `ψ : Γ(G, 𝒪_G) → k`" (that was the iter-128 body that collapsed to
   zero); it is **chart-base-change** `k ⊗_{Γ(G,V)} Ω_{Γ(G,V) / Γ(Spec k, U)}`
   on an affine chart `V ⊆ G.left` around the identity-section image.
   Step 1 of the bridge proof needs to be re-framed to start from the
   chart-base-change body, not the global-Γ body.

2. **`lem:GrpObj_lieAlgebra_finrank` proof Step 1 (~line 191)** —
   currently reads "By cref{lem:GrpObj_cotangent_bridge}, the iter-128
   evaluate-then-extend-scalars body of cref{lem:GrpObj_cotangentSpace}
   is `k`-linearly isomorphic to `𝔪/𝔪²`, …, it suffices to compute
   `finrank k (𝔪/𝔪²) = n`." Under Replacement (B) this is **vestigial**:
   the bridge lemma `lem:GrpObj_cotangent_bridge` is `\notready` and
   is no longer the live closure path. The active closure under (B)
   is the cross-check route described in Step 4 / line 203:
   `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
   on the chart gives `Module.rank Γ(G,V) Ω[Γ(G,V)/Γ(Spec k, U)] = n`;
   `Module.finrank_baseChange` brings the rank down to `k`. Step 1
   should be **rewritten** to describe this direct path from the
   chart-base-change body, removing the bridge-to-`𝔪/𝔪²` framing from
   the live closure. The bridge framing should be relocated to a
   final paragraph as "alternative canonical route (currently
   deferred; relevant only if a non-rigidity consumer materialises)".

3. **`lem:GrpObj_lieAlgebra_finrank` closure-path paragraph (~line 203)**
   — already reads "Iter-130 closure path under Replacement (B)" and
   lists the four Mathlib names. This is the correct active closure.
   The paragraph should be **promoted from a postscript to the primary
   proof body** (Step 1 + Step 2) and the iter-128-era Step 1
   (bridge-to-𝔪/𝔪²) should be **demoted to a "Step 3 (alternative
   canonical route, deferred)"** paragraph or similar.

4. **`lem:GrpObj_cotangentSpace` proof block (~lines 112-122)** — looks
   OK at first reading (describes the chart-base-change construction);
   please double-check it reflects the iter-131 `Classical.choose`-chain
   body shape accurately (the iter-130 prose still described the body
   as "passes through `Classical.choice` to bridge `Prop` and `Type`"
   which is the iter-130 body, not the iter-131 body). The iter-131
   body is a pure-term `noncomputable def` with `let`-bindings using
   `Classical.choose` / `Classical.choose_spec` accessors; the outer
   expression is the explicit `(ModuleCat.extendScalars _).obj
   (ModuleCat.of _ Ω[…])`.

5. **Iter-130/iter-131 lemma signature stubs** — the inline `\lean{...}`
   stubs in `lem:GrpObj_cotangent_bridge`'s `% Lean signature stub`
   comment block (lines 127–135) still describes the iter-128 body
   construction in places ("the iter-128 body construction"). Update
   to reference the iter-130 body shape consistently and add a sentence
   noting that this is the **iter-130+ build target / `\notready`**
   under Replacement (B) — the bridge is deferred until a non-rigidity
   consumer surfaces a canonicity requirement.

6. **Add a new mini-section "Iter-131 Classical.choose-chain body shape"**
   under `\subsection{Piece (i): sub-lemma decomposition for iter-128+ build}`
   that briefly documents what the iter-131 body shape looks like (as a
   Lean encoding note for future readers): the iter-131 body is a
   pure-term `noncomputable def` whose outer expression is
   `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G,V) Ω[…])`
   with `U, V, e, ψ_V` introduced via `Classical.choose` / `Classical.choose_spec`
   on `Scheme.smooth_locally_free_omega`. Also note the iter-131
   companion lemma `cotangentSpaceAtIdentity_eq_extendScalars` which
   serves as a `rfl`-closed rewrite handle to the explicit extendScalars
   form (for downstream consumers, notably the rank lemma).

## Required content

- **Rewrite of `lem:GrpObj_lieAlgebra_finrank` proof block**: 4-step
  proof in the order **(new) Step 1 = chart-base-change rank**, **Step 2
  = base-change to `k`**, **Step 3 (alternative deferred route via
  `𝔪/𝔪²`)**, **Step 4 (dualisation conclusion `finrank 𝔤 = n`)**.
  The Mathlib names in the new Step 1+2 (the live closure) must
  match those re-verified iter-132:
  - `Scheme.smooth_locally_free_omega` (project) — supplies the
    existential `∃ U V e (hxV : x₀ ∈ V) (hU hV : IsAffineOpen …)
    (hfree : Module.Free Γ(G,V) Ω[Γ(G,V)/Γ(Spec k, U)])
    (hrank : Module.rank Γ(G,V) Ω[…] = ↑n)` directly.
  - `Module.finrank_baseChange` [verified iter-132,
    `Mathlib.LinearAlgebra.Dimension.Constructions`]:
    `Module.finrank R (TensorProduct S R M') = Module.finrank S M'`
    when `S` is a commutative semiring with `StrongRankCondition`,
    `M'` is `Module.Free S`, and `R` is an `S`-algebra with
    `StrongRankCondition`.
  - `Module.finrank_eq_of_rank_eq` [verified iter-132,
    `Mathlib.LinearAlgebra.Dimension.Finrank`]:
    `Module.rank R M = ↑n → Module.finrank R M = n`.
  - `Algebra.TensorProduct.instFree` [verified iter-132,
    `Mathlib.RingTheory.TensorProduct.Free`] supplies
    `Module.Free k (TensorProduct Γ(G,V) k Ω[…])` (informational, not
    on the rank-lemma critical path under Replacement (B), but still
    relevant for the consumer `omega_free`).

- **New mini-section** documenting the iter-131 body shape (per item 6
  above), placed at the end of `\subsection{Piece (i): sub-lemma
  decomposition for iter-128+ build}`. Should be ~10–15 lines of
  LaTeX prose; pin the Lean encoding for future readers.

- **Demote the "alternative canonical route" (`𝔪/𝔪²` bridge)** to a
  single paragraph at the bottom of the rank-lemma proof noting:
  (a) `lem:GrpObj_cotangent_bridge` is `\notready` and currently
  vestigial under Replacement (B); (b) the iter-131 strategy-critic
  Q4 collapse documented this in STRATEGY.md (the trio (definition +
  bridge + rank) collapses to a duo (definition + rank) on the live
  (B) path); (c) the bridge re-enters the live path only if trigger
  (a') at iter-133+ piece (i.b) fires.

- **Verify `lem:GrpObj_cotangentSpace` proof block (lines 112-122)**
  describes the iter-131 body shape accurately; update prose if it
  still describes "passes through `Classical.choice`" (iter-130
  framing).

## Out of scope

- Do NOT touch `lem:GrpObj_mulRight_globalises` (line 206), 
  `lem:GrpObj_omega_free` (line 233), or `lem:GrpObj_omega_rank_eq_dim`
  (line 246). These are piece (i.b) and (i.c) `\notready` lemmas
  scheduled for iter-133+ / iter-137+; their prose is fine as-is.
- Do NOT touch the chapter intro (`§ 1`), § Statement (`thm:rigidity_over_kbar`),
  § Proof decomposition (C.2.b–C.2.e), § The shared cotangent-vanishing
  Mathlib pile (pieces (i)/(ii)/(iii)/(iv) intro list — only piece (i)'s
  sub-decomposition prose may be changed).
- Do NOT touch § Use in the project or § Mathlib status (chapter
  footer sections; they reference downstream consumers and are stable).
- Do NOT add `\leanok` markers (those are deterministically managed by
  `sync_leanok`).
- Do NOT add new declarations or rename existing labels. Re-use the
  three existing labels (`lem:GrpObj_cotangentSpace`,
  `lem:GrpObj_cotangent_bridge`, `lem:GrpObj_lieAlgebra_finrank`).
- Do NOT touch any other blueprint chapter.

## References

- `analogies/cotangent-body-shape.md`: iter-131 mathlib-analogist
  verdict on the `Classical.choose`-chain refactor and the rank-lemma
  closure chain. Specifically § Bridge lemma list (closure chain
  under Classical.choose-chain (B)) lines 359–371 list the 8 steps
  of the closure.
- `analogies/lieAlgebra-rank-bridge.md`: iter-129 mathlib-analogist
  verdict on the iter-128 zero-collapse defect + the Replacement (B)
  recommendation. Specifically the 5-step diagnostic for the iter-128
  zero collapse (referenced from STRATEGY.md § "Direct over-k
  rigidity / Standalone scheme-level cotangent sheaf").
- `AlgebraicJacobian/Cotangent/GrpObj.lean` (iter-131 final): the
  current Lean source — the body to align prose against.
- `AlgebraicJacobian/Differentials.lean` lines 124–143:
  `smooth_locally_free_omega`'s existential signature (returns
  `∃ U V e (hxV : x₀ ∈ V) (hU hV : IsAffineOpen) (hfree : Module.Free
  Γ(G,V) Ω[…]) (hrank : Module.rank Γ(G,V) Ω[…] = ↑n)`).

## Expected outcome

After this writer pass, `blueprint/src/chapters/RigidityKbar.tex` § Piece
(i) reads coherently against the iter-131 Lean body of
`cotangentSpaceAtIdentity`. The rank lemma `lem:GrpObj_lieAlgebra_finrank`'s
proof should describe the **live closure under Replacement (B)** as
Step 1+2 (chart-base-change rank from `smooth_locally_free_omega`'s
existential's `hrank`/`hfree`, plus `Module.finrank_baseChange`
+ `Module.finrank_eq_of_rank_eq`); the `𝔪/𝔪²` bridge route is
documented as a deferred alternative (Step 3 or footer paragraph). The
companion iter-131 lemma `cotangentSpaceAtIdentity_eq_extendScalars` is
named in a new mini-section as the recommended rewrite handle for
downstream consumers. Sub-step (i.a)'s prose then aligns with what the
iter-132 prover lane (rank lemma) will actually formalize.
