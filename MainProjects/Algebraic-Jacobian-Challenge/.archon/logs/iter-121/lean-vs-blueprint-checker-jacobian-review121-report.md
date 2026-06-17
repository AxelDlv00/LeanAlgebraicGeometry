# Lean ↔ Blueprint Check Report

## Slug
jacobian-review121

## Iteration
121

## Files audited
- Lean: `AlgebraicJacobian/Jacobian.lean`
- Blueprint: `blueprint/src/chapters/Jacobian.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.IsAlbanese}` (chapter: def:IsAlbanese)
- **Lean target exists**: yes (`Jacobian.lean:57`).
- **Signature matches**: partial. Lean takes `(C, P, J)` with `[GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible J.hom]` as binder typeclasses; existential is `∃ α : C ⟶ J, P ≫ α = η[J] ∧ ∀ {A} [...] (f) (_), ∃! (g : J ⟶ A), f = α ≫ g`. Blueprint prose says the produced unique `g` is "a morphism of group schemes"; the Lean only requires `g : J ⟶ A` (a morphism in `Over (Spec k)`, i.e., a scheme-over-$k$ morphism). The classical fact is that any such `g` is automatically a group homomorphism, but this is not part of the Lean signature. Minor terminological gap.
- **Proof follows sketch**: N/A (definition).
- **notes**: Remark `rem:IsAlbanese_typeclasses` correctly notes the typeclass-binder encoding. Blueprint $\iota \circ g$ notation = Lean `α ≫ g` (diagrammatic order).

### `\lean{AlgebraicGeometry.IsAlbanese.ofCurve}` (chapter: def:IsAlbanese_ofCurve)
- **Lean target exists**: yes (`Jacobian.lean:67`).
- **Signature matches**: yes. `(h : IsAlbanese C P J) : C ⟶ J := Classical.choose h`.
- **Proof follows sketch**: yes — body is `Classical.choose h` as the blueprint says.
- **notes**: —

### `\lean{AlgebraicGeometry.IsAlbanese.comp_ofCurve}` (chapter: lem:IsAlbanese_comp_ofCurve)
- **Lean target exists**: yes (`Jacobian.lean:72`).
- **Signature matches**: yes. `P ≫ h.ofCurve = η[J]` matches "$P \circ h.\mathtt{ofCurve} = \eta_J$".
- **Proof follows sketch**: yes — `(Classical.choose_spec h).1`.
- **notes**: —

### `\lean{AlgebraicGeometry.IsAlbanese.exists_unique_ofCurve_comp}` (chapter: lem:IsAlbanese_exists_unique_ofCurve_comp)
- **Lean target exists**: yes (`Jacobian.lean:78`).
- **Signature matches**: yes. `∃! (g : J ⟶ A), f = h.ofCurve ≫ g`.
- **Proof follows sketch**: yes — `(Classical.choose_spec h).2 f hf`.
- **notes**: Same group-scheme-morphism terminological slip as `def:IsAlbanese`.

### `\lean{AlgebraicGeometry.IsAlbanese.unique}` (chapter: thm:IsAlbanese_unique)
- **Lean target exists**: yes (`Jacobian.lean:88`).
- **Signature matches**: yes. `∃! (e : J₁ ⟶ J₂), h₂.ofCurve = h₁.ofCurve ≫ e`.
- **Proof follows sketch**: yes. The Lean tactic block constructs `g`, `h` in both directions, exhibits `g ≫ h = 𝟙 J₁` and `h ≫ g = 𝟙 J₂` as the standard universal-property argument, then exposes only `(g, hg_eq, hg_unique)` — matching Remark `rem:IsAlbanese_unique_iso` exactly ("invertibility witnesses are computed but not retained in the return type").
- **notes**: —

### `\lean{AlgebraicGeometry.JacobianWitness}` (chapter: def:JacobianWitness)
- **Lean target exists**: yes (`Jacobian.lean:143`).
- **Signature matches**: yes. Seven fields: `J`, `grpObj`, `proper`, `smooth`, `geomIrred`, `smoothGenus`, `isAlbaneseFor`. Blueprint enumerates the same seven in the same order.
- **Proof follows sketch**: N/A (structure).
- **notes**: The `smooth`/`smoothGenus` redundancy is correctly documented in `rem:JacobianWitness_smooth_redundancy`. The quantifier-reversal (single intrinsic `J`, `isAlbaneseFor : ∀ P, IsAlbanese C P J`) is correctly documented in `rem:JacobianWitness_quantifier_order`.

### `\lean{AlgebraicGeometry.nonempty_jacobianWitness}` (chapter: thm:nonempty_jacobianWitness)
- **Lean target exists**: yes (`Jacobian.lean:176`).
- **Signature matches**: yes. Takes `C : Over (Spec (.of k))` with three typeclass binders (`SmoothOfRelativeDimension 1 C.hom`, `IsProper C.hom`, `GeometricallyIrreducible C.hom`); returns `Nonempty (JacobianWitness C)`. No genus parameter, no `k`-rational point hypothesis — consistent with the rewritten C.2 sub-step which explicitly states "the protected signature of Theorem~\ref{thm:nonempty_jacobianWitness} does not assume $C(k) \neq \emptyset$".
- **Proof follows sketch**: N/A — Lean body is `sorry`. This is the single Phase-C sorry, per the directive (M2 milestone queued behind M1).
- **notes**: The blueprint's `\leanok` inside the proof block at `Jacobian.tex:249` is incorrect since the Lean proof is `sorry`. This is `sync_leanok`'s deterministic responsibility, not the reviewer's — flagged as informational. (Statement-level `\leanok` at line 239 is correct: declaration exists with a sorry body.)

### `\lean{AlgebraicGeometry.Jacobian}` (chapter: def:Jacobian)
- **Lean target exists**: yes (`Jacobian.lean:199`).
- **Signature matches**: yes. `noncomputable def Jacobian (C ...) : Over (Spec (.of k)) := (jacobianWitness C).J`.
- **Proof follows sketch**: N/A (definition body matches blueprint prose: "underlying scheme of a (uniform-over-$P$) Albanese witness").
- **notes**: —

### `\lean{AlgebraicGeometry.Jacobian.instGrpObj}` (chapter: thm:Jacobian_grpObj)
- **Lean target exists**: yes (`Jacobian.lean:209`).
- **Signature matches**: yes. `GrpObj (Jacobian C) := (jacobianWitness C).grpObj`.
- **Proof follows sketch**: yes. Lean projects `.grpObj` from the witness; blueprint proof says "$\Jac(C)$ inherits it by projection" — matches verbatim.
- **notes**: —

### `\lean{AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus}` (chapter: thm:Jacobian_smooth_genus)
- **Lean target exists**: yes (`Jacobian.lean:213`).
- **Signature matches**: yes. `SmoothOfRelativeDimension (genus C) (Jacobian C).hom := (jacobianWitness C).smoothGenus`.
- **Proof follows sketch**: yes. Projection from `.smoothGenus` matches the blueprint's "no separate dimension calculation is needed on the Lean side".
- **notes**: —

### `\lean{AlgebraicGeometry.Jacobian.instIsProper}` (chapter: thm:Jacobian_proper)
- **Lean target exists**: yes (`Jacobian.lean:217`).
- **Signature matches**: yes. `IsProper (Jacobian C).hom := (jacobianWitness C).proper`.
- **Proof follows sketch**: yes.
- **notes**: —

### `\lean{AlgebraicGeometry.Jacobian.instGeometricallyIrreducible}` (chapter: thm:Jacobian_geomIrred)
- **Lean target exists**: yes (`Jacobian.lean:220`).
- **Signature matches**: yes. `GeometricallyIrreducible (Jacobian C).hom := (jacobianWitness C).geomIrred`.
- **Proof follows sketch**: yes.
- **notes**: —

## Red flags

### Placeholder / suspect bodies
- `AlgebraicGeometry.nonempty_jacobianWitness` at `Jacobian.lean:179`: body is `:= sorry` (the project's single Phase-C sorry, explicitly authorised by the chapter as the "single explicit foundational hypothesis"; this is a deferred-existence theorem with a detailed proof sketch in the chapter and a known M2 milestone queued behind M1 per the directive). Not a defect — recording for completeness.

### Excuse-comments
None. The Lean file's comments are informational (docstrings and the "Forbidden shortcut (sanity check)" header note explaining why the terminal-object short-circuit is wrong); they are not excuses for incorrect/incomplete code.

### Axioms / Classical.choice on non-trivial claims
- `Jacobian.lean:184` (`jacobianWitness`): `Classical.choice (nonempty_jacobianWitness C)`. This is the canonical extraction of a witness from an existence statement and is authorised by the chapter (see `thm:nonempty_jacobianWitness` and the discussion in `def:Jacobian`). Not a red flag.
- `Jacobian.lean:67,72,78`: `Classical.choose` / `Classical.choose_spec` on the `IsAlbanese` existential — authorised by the chapter (Definition `def:IsAlbanese_ofCurve` says "obtained by \texttt{Classical.choose} on the existential body of $h$"). Not a red flag.

## Unreferenced declarations (informational)

- `AlgebraicGeometry.geometricallyIrreducible_id_Spec` (`Jacobian.lean:120`): docstring marks it as "a small helper needed for the genus-0 case of `Jacobian`". The chapter does not currently reference it. Acceptable as a helper but worth a `\lean{...}` block if it survives the M2 work (when `nonempty_jacobianWitness` is discharged, this helper feeds the genus-0 leaf of Sub-step C.3). Minor.
- `AlgebraicGeometry.jacobianWitness` (`Jacobian.lean:184`): the `Classical.choice` extraction. The chapter mentions it by name inside the proof of `thm:Jacobian_grpObj` ("$\Jac(C) = (\mathrm{jacobianWitness}\, C).J$") but does not give it its own `\lean{...}` block. This is a Lean-internal extraction step; acceptable as an unreferenced helper but a `\lean{...}` hint would tighten Layer-I traceability. Minor.

## Blueprint adequacy for this file

- **Coverage**: 12/14 Lean declarations have a corresponding `\lean{...}` block in the chapter. 2 unreferenced declarations: `geometricallyIrreducible_id_Spec` and `jacobianWitness` (both helpers, both acceptable as unreferenced; flagged minor above).
- **Proof-sketch depth**: adequate. The C.2 sub-step rewrite of `thm:nonempty_jacobianWitness` provides seven-step structural detail (C.2.a–C.2.g) that is substantially richer than the previous one-sentence sketch and gives a future prover concrete sub-goals: the rigidity statement over $\bar k$, the project-side reduction to `GrpObj.eq_of_eqOnOpen`, the image-dimension dichotomy, the Mumford/Hartshorne keystone, set-to-scheme promotion via reduced-source/separated-target, Galois descent, and a named gap declaration. Sufficient for prover guidance.
- **Hint precision**: precise. All 12 `\lean{...}` hints resolve to the exact declaration names in the file (namespace `AlgebraicGeometry`, no `Scheme.` prefix — note that the directive's reference to `\lean{AlgebraicGeometry.Scheme.nonempty_jacobianWitness}` appears to be a minor typo in the directive itself; the blueprint correctly uses `\lean{AlgebraicGeometry.nonempty_jacobianWitness}` at line 242, matching the Lean target).
- **Generality**: matches need. The witness bundle reversed-quantifier encoding (`def:JacobianWitness` and `rem:JacobianWitness_quantifier_order`) precisely matches how `AbelJacobi.Jacobian.ofCurve` consumes the per-`P` data, with no parallel API gap.
- **Recommended chapter-side actions**:
  - **Major**: Line 376 (Mathlib infrastructure summary, bullet $(\gamma)$) still describes the genus-0 prerequisite as "the rigidity theorem $\Hom(\mathbb P^1_k, A) = A(k)$ together with the genus-$0$ identification $C \cong \mathbb P^1_k$ for a smooth proper geometrically irreducible curve with a $k$-rational point". This drifts from the C.2 rewrite, which deliberately states rigidity over $\bar k$ and uses Galois descent precisely because the protected signature of `thm:nonempty_jacobianWitness` does not assume $C(k) \neq \emptyset$. The summary bullet should either (a) be reworded to "the rigidity theorem for $\mathbb P^1_{\bar k} \to A$ together with Galois descent of morphism equality" mirroring sub-steps C.2.d–C.2.f, or (b) at least drop the parenthetical "with a $k$-rational point" hypothesis from the genus-0 identification clause.
  - **Major**: Line 387 (Layer I --- direct definition) describes the genus-0 case as "the witness's universal property in that case implicitly carries the rigidity content $\Hom(\mathbb P^1_k, A) = A(k)$". Same stale framing as line 376 — should be tightened to refer to the $\bar k$-side rigidity + Galois descent content matching C.2, or rephrased generically as "the rigidity content for proper rational curves on an abelian variety".
  - **Minor**: Statement of `def:IsAlbanese` calls the universal factorising morphism "a morphism of group schemes $g \colon J \to A$"; the Lean signature only requires `g` to be a morphism of $k$-schemes (any such `g` happens to be a homomorphism by the universal property, but this is a consequence, not a requirement). Either weaken the prose to "morphism of $k$-schemes $g \colon J \to A$ (which is automatically a homomorphism of group schemes by the universal property)", or strengthen the Lean signature in a future refactor.
  - **Informational** (for `sync_leanok` to handle, not a chapter-writer action): `\leanok` inside the proof block of `thm:nonempty_jacobianWitness` (`Jacobian.tex:249`) does not match the Lean state — the Lean proof is `sorry`. Defer to the deterministic `sync_leanok` phase.
  - **Minor**: Consider adding `\lean{...}` blocks for `AlgebraicGeometry.geometricallyIrreducible_id_Spec` (genus-0 helper for Sub-step C.3) and `AlgebraicGeometry.jacobianWitness` (`Classical.choice` extraction underpinning Layer I) if they survive the M2 work — improves traceability without forcing immediate action.

## Severity summary

- **must-fix-this-iter**: none. The single `:= sorry` is the project's authorised deferred foundational hypothesis (per `thm:nonempty_jacobianWitness` and the chapter's "single explicit foundational hypothesis" statement). The C.2 sub-step prose is consistent with the protected Lean signature (no $C(k) \neq \emptyset$, no genus parameter, quantifies over a smooth proper geometrically irreducible curve over $\Spec k$). The pre-known `GrpObj.eq_of_eqOnOpen` source-side mismatch is honestly documented in C.2.b as a forward design issue and is not in scope for this iter (per directive).
- **major** (×2):
  - `Jacobian.tex:376` bullet $(\gamma)$ — stale "$\Hom(\mathbb P^1_k, A) = A(k)$ + $C \cong \mathbb P^1_k$ with $k$-rational point" framing inconsistent with the rewritten C.2.
  - `Jacobian.tex:387` Layer I item — same stale "$\Hom(\mathbb P^1_k, A) = A(k)$" framing.
- **minor** (×3):
  - `def:IsAlbanese` says "morphism of group schemes $g$" where the Lean signature only requires a scheme morphism (factual prose-vs-signature drift).
  - `geometricallyIrreducible_id_Spec` and `jacobianWitness` lack `\lean{...}` blocks (genuine helpers; promotion optional, not blocking).
  - `Jacobian.tex:249` proof-block `\leanok` mismatch (sync_leanok's responsibility).

Overall verdict: **Aligned** — the iter-121 rewrite of the C.2 sub-step is mathematically faithful to the protected signature of `nonempty_jacobianWitness` and the Lean declarations all resolve correctly against their `\lean{...}` hints; the only chapter-side polish needed is rewording the two stale summary phrases (lines 376, 387) that still use the old "$\Hom(\mathbb P^1_k, A) = A(k)$" framing.
