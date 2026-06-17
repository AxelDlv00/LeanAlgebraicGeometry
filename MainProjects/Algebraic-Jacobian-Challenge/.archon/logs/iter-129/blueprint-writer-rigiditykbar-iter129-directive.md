# Blueprint Writer Directive

## Slug
rigiditykbar-iter129

## Chapter
`blueprint/src/chapters/RigidityKbar.tex`

## Strategy context

Per the iter-127 over-k commitment, the M2.a `rigidity_over_kbar` declaration is built over an arbitrary base field `k` (no algebraic-closure hypothesis). Iter-128 added the first piece-(i.a) Lean declaration `AlgebraicGeometry.GrpObj.lieAlgebra` to `AlgebraicJacobian/Cotangent/GrpObj.lean` with a kernel-clean body, but the iter-128 review-phase flagged three must-fix-iter-129 items the chapter must address:

1. The `\lean{...}` hint on `lem:GrpObj_lieAlgebra` did not pin a signature stub, allowing the prover to hardcode `[SmoothOfRelativeDimension 1 G.hom]` — too narrow for the downstream consumer `thm:rigidity_over_kbar` which applies the declaration to an abelian variety of arbitrary relative dimension. Iter-129 refactor (running in parallel) relaxes the signature to `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` AND renames `lieAlgebra` → `cotangentSpaceAtIdentity`. The chapter must update its `\lean{...}` hint to match, include a signature stub, and pin the dualisation convention.

2. The chapter's `\begin{proof}` of `lem:GrpObj_lieAlgebra` (lines 105-109) sketches only the `𝔪/𝔪²`-stalk route via Mathlib's local-ring cotangent infrastructure (the prose says `IsRegularLocalRing.cotangentSpace` — **this is a phantom name; the verified Mathlib declaration is `Ideal.IsLocalRing.CotangentSpace`**). The actual iter-128 Lean body of `lieAlgebra` (now to-be-renamed `cotangentSpaceAtIdentity`) routes through `relativeDifferentialsPresheaf G.hom` evaluated at the top open + `ModuleCat.extendScalars`. The chapter must author the **rank-lemma bridge** between the evaluate-then-extend-scalars body construction and the `𝔪/𝔪²` cotangent space, so the iter-130+ rank-lemma prover lane has a clear closure path.

3. The chapter must fix the phantom Mathlib name (`IsRegularLocalRing.cotangentSpace` → `Ideal.IsLocalRing.CotangentSpace`) anywhere it appears in prose.

Additionally, two iter-128 "soon"-items are now eligible for blueprint-writer attention this iter as part of the bundle:

4. The `\lean{...}` hint on `lem:GrpObj_lieAlgebra_finrank` (line 113) — currently mid-grade; add an inline signature-stub to prevent the iter-130+ rank-lemma scaffold from regressing.

5. The chapter's variable `kbar` (a legacy from the iter-126 over-`k̄` framing) is now misleading post over-k commitment. The Lean signature variable is `kbar` but used as `[Field kbar]` — purely a variable name. This rename is **low-priority and out-of-scope for this writer pass** (per the iter-129 plan agent: scheduled iter-130+ cleanup; the rename does not affect Lean compilation).

## What to write

### A. Update `lem:GrpObj_lieAlgebra` → rename declaration to `cotangentSpaceAtIdentity`, pin signature stub, pin dualisation convention

The iter-129 refactor renames the Lean declaration `AlgebraicGeometry.GrpObj.lieAlgebra` → `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`. Update the chapter accordingly:

1. **Replace the `\lean{...}` hint** on the lemma block. Old (line 95):

```
\lean{AlgebraicGeometry.GrpObj.lieAlgebra}
```

New: include the renamed target AND a signature stub. Suggested form (you may polish):

```
\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}
% Lean signature stub (pinned post-iter-129 fixup):
%   noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k)))
%       [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
%       [IsProper G.hom] [GeometricallyIrreducible G.hom] : ModuleCat k
```

2. **Rewrite the lemma's prose** to reflect the rename + the cotangent (no-dualisation) convention. The body of the iter-128 Lean construction returns `η_G^* Ω_{G/k}` directly, i.e. the cotangent at the identity (`𝔤^∨`), not its dual `𝔤`. The encoding note must be tightened from "either convention" to **"the chosen convention is the cotangent `𝔤^∨` (no dualisation in the body); downstream consumers needing `𝔤` take `Module.Dual k (cotangentSpaceAtIdentity G)`."**

   The lemma's name in human-readable form (the `[(i.a) Lie algebra of a group scheme at the identity]` annotation on line 93) should become `[(i.a) Cotangent space at the identity of a group scheme]` to match the rename. Keep the cross-references to `\cref{lem:GrpObj_lieAlgebra}` updated elsewhere in the chapter — rename the label to `lem:GrpObj_cotangentSpace` for consistency. Update every `\cref{lem:GrpObj_lieAlgebra}` and `\uses{lem:GrpObj_lieAlgebra}` site within the chapter.

3. **Update the lemma prose** (lines 96-100). Old:

```
The pullback along the identity section $\eta_G$ of the relative cotangent presheaf,
\[
  \mathfrak g^{\vee} \;:=\; \eta_G^{*}\,\Omega_{G/k},
\]
is a finitely generated free $k$-module. Its $k$-linear dual $\mathfrak g$ is the \emph{Lie algebra of $G$} as a $k$-vector space (the bracket structure is not used in the rigidity argument and is not packaged here).
```

You may polish, but the rewrite should:
- Drop the "Lie algebra is $\mathfrak g$, its dual" framing and reposition the lemma as a statement *about* $\mathfrak g^\vee$ (the cotangent), with a one-line remark mentioning $\mathfrak g = \mathfrak g^{\vee\vee}$ is recovered by `Module.Dual`.
- Pin the dualisation convention: the Lean declaration returns $\mathfrak g^\vee$.
- Preserve the "finite-generated free $k$-module" claim and its dependency on `\uses{}` chain.

### B. Author the rank-lemma bridge

The iter-128 Lean body computes `(ModuleCat.extendScalars ψ.hom).obj (Ω_{G/k}(\top))` where `ψ : Γ(G.left, ⊤) ⟶ k` is the ring map induced by the identity section. The chapter's current proof of `lem:GrpObj_lieAlgebra` (lines 105-109) sketches the stalk-side route via $\mathfrak m/\mathfrak m^2$ of the local ring at the identity.

**Add a new lemma block (or expand the proof of `lem:GrpObj_cotangentSpace`) sketching the bridge:**

The required bridge is the canonical isomorphism

```
(ModuleCat.extendScalars ψ.hom).obj (Ω_{G/k}(⊤))   ≅   m_{η_G} / m_{η_G}²
```

as `k`-modules, where the RHS is `Ideal.IsLocalRing.CotangentSpace` applied to the local ring `(Scheme.Hom.stalkMap η_G.left).toRingHom ∘ ψ`'s domain (i.e. the local ring of `G` at the identity).

Sketch of the bridge:
1. Global sections of $\Omega_{G/k}$ on $G$ pull back to global sections on $\Spec k$ along $\eta_G$. By the universal property of $\Omega_{G/k}$ as the Kähler-differential module, this is the differential module of the local map $\mathcal O_{G, \eta_G} \to k$ (composing the localisation $\Gamma(G, \mathcal O_G) \to \mathcal O_{G, \eta_G}$ with the residue map).
2. For a local ring $(R, \mathfrak m, k)$ with residue map $\pi : R \to k$, the cotangent space $\mathfrak m / \mathfrak m^2$ is canonically isomorphic to $k \otimes_R \Omega_{R/k}$ (this is the standard $\Omega_{R/k} / \mathfrak m \Omega_{R/k} \cong \mathfrak m/\mathfrak m^2$ identification when $R$ is a local $k$-algebra with residue field $k$; cf. Stacks Tag 02G1).
3. Combining: the iter-128 evaluate-then-extend-scalars module is canonically the cotangent space $\mathfrak m_{η_G} / \mathfrak m_{η_G}^2$.

Once the bridge is established, the standard "regular local ring ⇒ cotangent is free of rank equal to Krull dimension" closes the rank lemma. The Mathlib name to anchor to is **`Ideal.IsLocalRing.CotangentSpace`** (the verified declaration in Mathlib `b80f227`; NOT the phantom `IsRegularLocalRing.cotangentSpace` that earlier prose mis-named — fix this everywhere in the chapter).

You may stage this bridge either:
- (Preferred) As a **new lemma block** with `\label{lem:GrpObj_cotangent_bridge}` between `lem:GrpObj_cotangentSpace` (renamed (i.a) lemma) and `lem:GrpObj_lieAlgebra_finrank` (rank lemma). The new block should sketch the bridge and explicitly name `Ideal.IsLocalRing.CotangentSpace` as the Mathlib anchor.
- Or by **expanding the existing proof** of `lem:GrpObj_cotangentSpace` to include the bridge sub-step before the regularity-of-stalk step.

### C. Update `lem:GrpObj_lieAlgebra_finrank` (rank lemma) to consume the bridge

The current proof (lines 123-126) is one sentence and does not name Mathlib pieces. Rewrite as a multi-step sketch that:
1. References the new bridge lemma (or the bridge sub-step) to connect the iter-128 evaluate-then-extend-scalars body to the cotangent space $\mathfrak m/\mathfrak m^2$.
2. Names `Ideal.IsLocalRing.CotangentSpace` as the Mathlib anchor for the cotangent module structure.
3. References `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` (the rank-pinning piece from `Differentials.tex`'s `thm:smooth_locally_free_omega`, which is already formalised in `AlgebraicJacobian/Differentials.lean` as `smooth_locally_free_omega`) to pin the rank to `n` from `[SmoothOfRelativeDimension n G.hom]`.
4. May reference `IsRegularLocalRing` for the regularity step.

This should mirror the level of Mathlib-anchor detail in `Differentials.tex`'s `thm:smooth_locally_free_omega` proof (which names 5 specific Mathlib closure pieces per the blueprint-reviewer's "model of detail" praise).

Also: **add an inline signature-stub to the `\lean{...}` hint on the rank lemma** (line 113). Match the form used in part A above.

### D. Update `\uses{}` graph

Cross-reference rename: every `\uses{lem:GrpObj_lieAlgebra}` site in `RigidityKbar.tex` must update to `\uses{lem:GrpObj_cotangentSpace}` (the new label). Check:
- `lem:GrpObj_lieAlgebra_finrank` (line 114) — currently `\uses{lem:GrpObj_lieAlgebra}`.
- `lem:GrpObj_mulRight_globalises` (line 131) — currently `\uses{lem:GrpObj_lieAlgebra}`.
- `lem:GrpObj_omega_free` (line 158) — currently `\uses{lem:GrpObj_lieAlgebra, lem:GrpObj_mulRight_globalises}`.
- `lem:GrpObj_omega_rank_eq_dim` (line 171) — currently `\uses{lem:GrpObj_omega_free, lem:GrpObj_lieAlgebra_finrank}`.
- `rem:piece_i_first_target` (line 183) — currently `\uses{lem:GrpObj_lieAlgebra, lem:GrpObj_lieAlgebra_finrank}`.

If the new bridge lemma `lem:GrpObj_cotangent_bridge` is added, wire it into `lem:GrpObj_lieAlgebra_finrank`'s `\uses{}`.

### E. Strip the `% NOTE (iter-128 review):` block

The `% NOTE (iter-128 review):` block at line 92 (the long comment immediately before `\begin{lemma}` of `lem:GrpObj_lieAlgebra`) was a placeholder noting the iter-129 must-fix items. After this iter-129 writer pass + the parallel refactor lane address them, this NOTE is stale and should be deleted (its content is now reflected in the rewritten chapter).

## Constraints

- Do NOT touch any other chapter file. The orphan chapter cleanup (`Modules_Monoidal.tex`, `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`) is handled by a separate parallel `blueprint-writer-orphan-chapters-iter129` dispatch.
- Do NOT touch `Jacobian.tex` § C.2.a–C.2.e over-$\bar k$ prose cleanup (also separate; deferred this iter).
- Do NOT touch `\leanok` markers anywhere. The deterministic `sync_leanok` phase handles those.
- Do NOT introduce new chapters or rename the existing chapter file.
- Each statement-level claim (lemma, theorem, definition) you author must include a `\label{...}`, a `\lean{...}` hint (or explicit "no Lean target" note if it's purely an intermediate prose lemma), and `\uses{...}` declarations for its prerequisites.
- Cross-references between renamed labels must use `\cref{...}` (the project's preferred form). Verify any `\ref{}` you add resolves under `leanblueprint`.

## Output (in your task_results report)

- Per-paragraph diff of what you wrote/changed.
- Confirmation that all `\uses{}` cross-references resolve (the dependency graph stays well-formed).
- The signature stubs you added (verbatim).
- Notes on any decisions where you deviated from this directive (with rationale).
- If `Ideal.IsLocalRing.CotangentSpace` is not actually present in Mathlib snapshot `b80f227` (use `lean_local_search` or `lean_leansearch` to verify), report this back as a STRATEGY-modifying finding so the plan agent can re-route to whatever Mathlib name is actually there.

## Validation

After your edit, the chapter should compile under `leanblueprint` (no broken `\cref`, all labels referenced exist). If you have access to `leanblueprint checkdecls`, run it as a final sanity check (it will fail on the renamed `\lean{...}` hint until the iter-129 refactor lane lands; the failure on `AlgebraicGeometry.GrpObj.lieAlgebra` is expected and EXPECTED for this iter, since the refactor and writer run in parallel — flag this in your report but do not consider it a writer error).
