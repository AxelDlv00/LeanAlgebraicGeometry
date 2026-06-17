# Lean ↔ Blueprint Check Report

## Slug
iter185-identitycomponent

## Iteration
185

## Files audited
- Lean: `AlgebraicJacobian/Picard/IdentityComponent.lean`
- Blueprint: `blueprint/src/chapters/Picard_IdentityComponent.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent}` (chapter: `def:identity_component_group_scheme`)

- **Lean target exists**: yes — L129, `noncomputable def IdentityComponent`
- **Signature matches**: yes
  - Blueprint: identity component of a k-group scheme locally of finite type; result is the identity component as a k-scheme.
  - Lean (elaborated): `{k : Type u} [Field k] (_G : Over (Spec (CommRingCat.of k))) [GrpObj _G] [LocallyOfFiniteType _G.hom] : Over (Spec (CommRingCat.of k))`
  - Hypotheses and return type match the blueprint prose. The `Over (Spec k)` encoding for a k-scheme is confirmed by the blueprint encoding section (§6, Lean Encoding).
- **Proof follows sketch**: N/A — body is `:= sorry` (iter-185 skeleton mandate). Blueprint proof sketch (EGA I 6.1.9 + connected-component construction) is present in the blueprint but not yet formalized.
- **`\leanok` status**: blueprint marks the statement block `\leanok`. Correct per sync_leanok policy: declaration exists with at least a sorry body.
- **Notes**: clean.

---

### `\lean{AlgebraicGeometry.GroupScheme.IdentityComponent.isOpenSubgroupScheme}` (chapter: `thm:identity_component_open_subgroup`)

- **Lean target exists**: yes — L157, `theorem IdentityComponent.isOpenSubgroupScheme`
- **Signature matches**: **no** — materially weakened relative to the blueprint pin.
  - Blueprint (`thm:identity_component_open_subgroup`) states **all four** Kleiman lem:agps(3) conclusions:
    1. G^0 is an open and closed subscheme of G (open immersion + closed immersion).
    2. The inclusion G^0 ↪ G is a k-group-scheme homomorphism (G^0 inherits a k-group-scheme structure).
    3. G^0 is of finite type over k and geometrically irreducible.
    4. Formation of G^0 commutes with base field extension: (G^0)_K ≅ (G_K)^0 for all K/k.
  - Blueprint encoding section (§6): "the bundled statement that the identity component is an open and closed subgroup scheme of finite type over k, geometrically irreducible, and that its formation commutes with extension of the base field — the four conclusions of Kleiman §5 Lem.~lem:agps~(3)."
  - Lean (elaborated): `Nonempty { f // IsOpenImmersion (Over.Hom.left f) ∧ IsClosedImmersion (Over.Hom.left f) }` — only conclusion (1) is present; conclusions (2), (3), (4) are absent.
- **Proof follows sketch**: N/A — body is `:= sorry`.
- **`\leanok` status**: blueprint marks the statement block `\leanok`. Mechanically correct (declaration exists), but misleading given the weakened statement.
- **Notes**: The Lean docstring (L136–162) contains an explicit excuse comment: "The full Kleiman conclusion also packages the group-subscheme property […], finite-type-ness over k, geometric irreducibility, and base-change-commutation. Those refinements live as separate instances / follow-up lemmas in iter-186+; the file-skeleton pins only the clopen open-immersion conclusion as a Nonempty-witness." This is an excuse comment on a declaration whose blueprint pin claims the full four-conclusion bundle. The Lean statement is a **weakened stand-in**, not the pinned target. **must-fix-this-iter.**

---

### `\lean{AlgebraicGeometry.Scheme.Pic0Scheme}` (chapter: `def:pic_zero_subscheme`)

- **Lean target exists**: yes — L193, `noncomputable def Pic0Scheme`
- **Signature matches**: yes
  - Blueprint: "the identity component (Pic_{C/k})^0 of the k-group scheme Pic_{C/k}, for C/k a smooth proper geometrically integral curve over k."
  - Lean (elaborated): `{k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom] : Over (Spec (CommRingCat.of k))`
  - Hypotheses (smooth of relative dimension 1, proper, geometrically integral) match the prose. Return type is `Over (Spec k)` (a k-scheme), consistent with the abstract substrate.
- **Proof follows sketch**: N/A — body is `:= sorry`.
- **`\leanok` status**: blueprint marks the statement block `\leanok`. Correct.
- **Notes**: clean.

---

### `\lean{AlgebraicGeometry.Scheme.PicScheme.degree}` (chapter: `def:divisor_degree_pic`)

- **Lean target exists**: yes — L234, `noncomputable def PicScheme.degree`
- **Signature matches**: partial — minor type-level narrowing.
  - Blueprint (definition block): degree as a function `Pic_{C/k}(k) → ℤ`; prose additionally describes it as a group homomorphism (additive on ⊗).
  - Blueprint encoding section (§6): "the group homomorphism Pic_{C/k}(k) → ℤ extracting the leading coefficient of the Hilbert polynomial."
  - Lean (elaborated): `(Spec (CommRingCat.of k) ⟶ (PicScheme C).left) → ℤ` — a plain function. The group-homomorphism structure (type `AddMonoidHom` or `... →+ ℤ`) is not encoded.
  - Docstring excuse: "The full group-homomorphism refinement / functoriality in k lives as a follow-up lemma in iter-186+; the file-skeleton pins only the underlying function."
  - Assessment: For a `def`, encoding the underlying function and proving the homomorphism property as a separate `theorem` is standard Lean practice and does not constitute a weakened definition. The set-theoretic function is correct; the group homomorphism property is a separate obligation. This is a **minor** gap — a follow-up `PicScheme.degree_isGroupHom` or `PicScheme.degree_addGroupHom` should be pinned in a future blueprint block.
- **Proof follows sketch**: N/A — body is `:= sorry`.
- **`\leanok` status**: blueprint marks the statement block `\leanok`. Correct.
- **Notes**: The group-homomorphism property should be promoted to a separate `\lean{...}`-pinned theorem in iter-186+.

---

### `\lean{AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety}` (chapter: `thm:pic_zero_is_abelian_variety`)

- **Lean target exists**: yes — L285, `theorem Pic0Scheme.isAbelianVariety`
- **Signature matches**: **no** — materially incomplete relative to the blueprint theorem block.
  - Blueprint (`thm:pic_zero_is_abelian_variety`) states **three components** in the theorem block:
    1. Pic^0_{C/k} is an abelian variety over k: smooth, proper, geometrically irreducible, commutative k-group scheme.
    2. Its dimension equals g = g(C): `dim_k Pic^0_{C/k} = g`.
    3. Its k-points are exactly degree-zero classes: `Pic^0_{C/k}(k) = ker(deg : Pic_{C/k}(k) → ℤ)`.
  - Lean (elaborated): `IsProper (Pic0Scheme C).hom ∧ Smooth (Pic0Scheme C).hom ∧ GeometricallyIrreducible (Pic0Scheme C).hom ∧ Nonempty (GrpObj (Pic0Scheme C))` — only component (1) is present; components (2) and (3) are absent.
  - **On `Nonempty (GrpObj ...)` vs. a direct GrpObj instance** (directive flag): The blueprint prose says "commutative k-group scheme" (existence of group structure). `Nonempty (GrpObj (Pic0Scheme C))` asserts existence of a group-object structure non-constructively. This is **compatible** with the blueprint prose given the sorry'd body of `Pic0Scheme`; one cannot derive a `GrpObj` instance on a typed-sorry def without Classical.choice. The Nonempty wrapping is the correct design for a skeleton. Not a new finding to flag.
  - **Missing dimension** (component 2): Lean docstring (L268–273) excuse comment: "Dimension g = g(C): not stated separately at the file-skeleton level (it requires dim_k (Pic0Scheme C).left = AlgebraicGeometry.genus C, which involves the Krull-dimension API); iter-186+ follow-up." This is an excuse comment deferring a claim that the blueprint theorem block includes in the formal statement.
  - **Missing k-points = ker(deg)** (component 3): Completely absent from the Lean statement and from the Lean docstring. No excuse comment — the claim was not deferred, it was overlooked.
- **Proof follows sketch**: N/A — body is `:= sorry`.
- **`\leanok` status**: blueprint marks the statement block `\leanok`. Mechanically correct (declaration exists), but misleading given the truncated statement.
- **Notes**: Both missing components appear inside the `\begin{theorem}...\end{theorem}` block in the blueprint, not in a follow-up corollary. They are part of the pinned formal statement. The Lean theorem proves a strict sub-conjunction of the blueprint theorem. **must-fix-this-iter.**

---

## Red flags

### Placeholder / suspect bodies

All five declarations have `:= sorry` bodies. This is **expected** for an iter-185 file-skeleton (the directive mandates skeleton work only; bodies are iter-186+ obligations). The sorry bodies themselves are not red flags.

### Excuse-comments

- `IdentityComponent.lean:L136–162` (docstring of `isOpenSubgroupScheme`): "Those refinements live as separate instances / follow-up lemmas in iter-186+; the file-skeleton pins only the clopen open-immersion conclusion as a Nonempty-witness." — The blueprint `\lean{...}` pin for `thm:identity_component_open_subgroup` specifies the four-conclusion bundle; the Lean declaration is a deliberate stand-in with a weaker type. This is an excuse comment on a declaration the blueprint pin claims should bundle all four conclusions.

- `IdentityComponent.lean:L268–273` (docstring of `isAbelianVariety`): "Dimension g = g(C): not stated separately at the file-skeleton level … iter-186+ follow-up." — The dimension claim is part of the blueprint theorem's formal statement; the Lean statement omits it with an explicit excuse.

### Axioms / Classical.choice on non-trivial claims

None. No `axiom` declarations. No `Classical.choice _` patterns.

---

## Unreferenced declarations (informational)

All five declarations in the Lean file have a corresponding `\lean{...}` reference in the blueprint. There are no unreferenced substantive declarations.

---

## Blueprint adequacy for this file

- **Coverage**: 5/5 Lean declarations have a corresponding `\lean{...}` block. 0 helpers + 0 unreferenced substantive declarations. Coverage is complete.

- **Proof-sketch depth**: **adequate** for four of five blocks. The proofs of `thm:identity_component_open_subgroup` (L149–186 of the TeX) and `thm:pic_zero_is_abelian_variety` (L382–442) reproduce the Kleiman argument in detail (EGA I 6.1.9, connected-product argument, quasi-projectivity via th:qpp&p, smoothness/dimension via cor:sm + ex:jac). The five-step proof sketch for the abelian-variety theorem is more than sufficient to guide formalization. No chapter-side expansion is needed.

- **Hint precision**: **mostly precise**, with one gap. The `\lean{...}` pins resolve to the correct Lean names. However, the blueprint encoding section (§6) describes `isOpenSubgroupScheme` as "the bundled statement that the identity component is an open and closed subgroup scheme of finite type over k, geometrically irreducible, and that its formation commutes with extension of the base field — the four conclusions." The hint correctly specifies the target content; the failure is that the prover (iter-185) did not match the pin. The blueprint pin itself is not at fault.

- **Generality**: **matches need**. The abstract identity-component substrate (`GroupScheme.IdentityComponent` + `isOpenSubgroupScheme`) is written at the right level of generality for the project. No parallel API was introduced.

- **Recommended chapter-side actions**: None critical. The blueprint is adequate and well-specified. Two optional improvements:
  - Add a `\lean{...}`-pinned follow-up theorem for `PicScheme.degree_addGroupHom` (the group homomorphism property of the degree map) to track that obligation.
  - The dimension equality `dim_k Pic^0_{C/k} = genus C` and the k-points characterization `Pic^0_{C/k}(k) = ker(deg)` should remain in the body of `thm:pic_zero_is_abelian_variety` (or be promoted to a paired corollary with a `\lean{...}` pin) so that the iter-186+ prover knows to include them in the Lean statement.

---

## Severity summary

### must-fix-this-iter

1. **`IdentityComponent.isOpenSubgroupScheme` (L157) — weakened statement + excuse comment.**
   Blueprint pin `thm:identity_component_open_subgroup` specifies four conclusions (Kleiman lem:agps(3)): (a) clopen subscheme, (b) group-scheme homomorphism, (c) finite type + geometrically irreducible, (d) base-change commutation. Lean statement only contains (a). Conclusions (b)–(d) are explicitly deferred in the docstring excuse comment. The Lean declaration is a structural stand-in, not the pinned target.
   **Action**: iter-186+ must upgrade `isOpenSubgroupScheme` to bundle all four Kleiman conclusions (add `GrpObj (IdentityComponent G)` instance / group-hom structure, `LocallyOfFiniteType`, `GeometricallyIrreducible`, and base-change isomorphism), or split into the correct separate declarations and update the `\lean{...}` pin.

2. **`Pic0Scheme.isAbelianVariety` (L285) — truncated statement, two claims from the blueprint theorem block absent.**
   The blueprint's `thm:pic_zero_is_abelian_variety` block states (in addition to abelian-variety structure): `dim_k Pic0Scheme C = genus C` and `Pic0Scheme C (k) = ker deg`. Both are absent from the Lean conclusion. The dimension omission has a docstring excuse comment; the k-points characterization was overlooked entirely.
   **Action**: iter-186+ must extend the Lean statement (or add a co-pinned corollary) to include `dim_k (Pic0Scheme C).left = AlgebraicGeometry.genus C` and `Pic0Scheme.kPoints C = (PicScheme.degree C).preimage {0}` (or equivalent kernel statement).

### minor

- **`PicScheme.degree` (L234)** — Lean type is a plain function (`... → ℤ`); blueprint encoding section says "group homomorphism." Standard Lean practice is to define the function and prove the homomorphism property separately; this is acceptable for a definition. A follow-up `\lean{...}`-pinned homomorphism theorem should be added to the blueprint in iter-186+.

---

**Overall verdict**: The iter-185 file-skeleton compiles cleanly (5 sorry warnings, 0 errors) and all five `\lean{...}` pins resolve to existing declarations. However, two declarations carry materially weaker Lean statements than their blueprint pins specify — `isOpenSubgroupScheme` captures only one of four required Kleiman conclusions, and `isAbelianVariety` omits the dimension equality and k-points characterization — both with excuse comments deferring the missing content to iter-186+. The blueprint chapter itself is adequate and well-specified; the failures are entirely on the Lean side. **2 must-fix-this-iter findings, 0 major, 1 minor.**
