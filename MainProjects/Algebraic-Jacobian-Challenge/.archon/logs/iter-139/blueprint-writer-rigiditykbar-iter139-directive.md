# Blueprint Writer Directive — iter-139, `RigidityKbar.tex`

## Slug

rigiditykbar-iter139

## Target chapter

`blueprint/src/chapters/RigidityKbar.tex`

## Strategy context

The project's over-k rigidity argument (`thm:rigidity_over_kbar`, the
Lean target is `AlgebraicGeometry.GrpObj.rigidity_over_kbar` in
`AlgebraicJacobian/RigidityKbar.lean`) decomposes its proof into the
**shared cotangent-vanishing pile** — pieces (i), (ii), (iii), (iv) of
the proof outline.

This iter is concerned with the closure of **piece (i.b)**
(`lem:GrpObj_omega_basechange_proj`), a load-bearing sub-lemma of the
shear-iso + functorial-globalisation argument. **Iter-138 prover lane**
on the Lean target
`AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two`
(`AlgebraicJacobian/Cotangent/GrpObj.lean:612`) landed PARTIAL with
substantive structural body cut: the iter-137-validated **Route (b)
inverse-direction-via-adjunction-transpose** skeleton landed
end-to-end, with the additive (`d_add`) and Leibniz (`d_mul`) laws of
the pointwise `KaehlerDifferential.D` derivation closed honestly.

**Three concrete sub-sorries remain**:

1. `d_app` at `Cotangent/GrpObj.lean:581` — the algebraic-coherence
   law of the pointwise derivation (zero on the source-presheaf
   morphism's image).
2. `d_map` at `Cotangent/GrpObj.lean:585` — cross-open naturality of
   the pointwise derivations.
3. `IsIso (basechange_along_proj_two_inv G)` at
   `Cotangent/GrpObj.lean:624` — the iso property of the constructed
   inverse map.

The iter-139 plan defers the iter-139 prover lane (per `blueprint-
reviewer-iter139` HARD GATE) to expand this chapter first, then
fire the prover lane in iter-140 against the now-complete blueprint.
The iter-140 prover lane will close all three sub-sorries (after
this chapter expansion); iter-139 mathlib-analogist already returned
**PROCEED with Route (b'2)** for the IsIso closure (a 5-line
`isIso_of_app_iso_module` helper via `PresheafOfModules.toPresheaf` +
`NatTrans.isIso_iff_isIso_app` reduces to per-open ModuleCat-iso
identification; ~195–365 LOC envelope).

## Required content

This dispatch makes the following targeted edits to
`RigidityKbar.tex`. **Preserve the rest of the chapter verbatim**;
chart-by-chart prose at L632–L638, the iter-135 NOTE at L470–L480,
the iter-137 NOTE at L492–L631 (chart-opacity blocker explanation +
Routes (a) and (b) descriptions), and the surrounding lemma blocks
must stay as-is.

### Edit 1: Add a `% NOTE iter-138:` block at the head of `lem:GrpObj_omega_basechange_proj`'s proof block (around `RigidityKbar.tex:489–491` immediately after `\leanok`)

This block records the iter-138 closure shape and the three remaining
sub-sorries. Content:

- Iter-138 prover lane chose **Route (b) inverse-direction-via-
  adjunction-transpose** over Route (a) chart-unfolding-helper for the
  reasons recorded in the iter-138 lean-vs-blueprint-checker (the
  Route (a) chart-unfolding helper hits the same `pullback`-opacity
  blocker as iter-137; Route (b) admits typeable derivation
  construction without unfolding `pullback`).
- Iter-138 introduced two top-level Lean helpers:
  `basechange_along_proj_two_inv_derivation`
  (`Cotangent/GrpObj.lean:547`, builds the pointwise inverse-direction
  derivation `D : ((pushforward ψ).obj LHS).Derivation' φ_G`) and
  `basechange_along_proj_two_inv` (`Cotangent/GrpObj.lean:596`, the
  inverse morphism obtained by `(DifferentialsConstruction.isUniversal' φ_G).desc`
  on `D`, then `(pullbackPushforwardAdjunction ψ).homEquiv.symm`).
- Iter-138 closed the d_add and d_mul laws of the pointwise
  derivation via `RingHom.map_add` / `RingHom.map_mul` on
  `(ψ.app X).hom` + `ModuleCat.Derivation.d_add` / `d_mul` on
  `KaehlerDifferential.D`. Three concrete sub-sorries remain;
  iter-140 prover lane attacks all three.
- Iter-138 negative lesson: `simp` with the obvious lemma names
  (`map_add`, `map_mul`, `ModuleCat.Derivation.d_add`, `d_mul`) does
  NOT fire inside the `Derivation.mk`-produced goals because the
  function passed to `Derivation.mk` appears as a beta-redex; the
  working pattern is `have h ... ; change ... ; rw [h] ; exact ...`
  (codified in the Lean docstring and in
  `.archon/.debug-feedback/debug_feedback.md`).

### Edit 2: Add a `% NOTE iter-138:` paragraph spelling out the d_app closure recipe

Insert at a suitable location (after Edit 1, before the chart-by-
chart prose at L632), spelling out the **mathematical** d_app
closure recipe:

> Let `φ_G : (G.hom.base⁻¹ O_{Spec k}) ⟶ G.left.presheaf` be the
> compatibility morphism for the structure map `G.hom : G.left ⟶ Spec k`,
> and `ψ : G.left.presheaf ⟶ (G⊗G).left.presheaf ∘ snd⁻¹` be the
> compatibility morphism for the second projection
> `pr_2 = snd G G : G ⊗ G ⟶ G`. The d_app law of the pointwise
> derivation requires showing, for each open `X` and each
> `a ∈ (G.hom.base⁻¹ O_{Spec k}).obj X`, the vanishing
> `KaehlerDifferential.D _ ((ψ.app X).hom (φ_G.app X a)) = 0`.
>
> This follows from the **categorical commutativity in `Over (Spec k)`**:
> `pr_1 = fst G G` and `pr_2 = snd G G` satisfy
> `fst.left ≫ G.hom = snd.left ≫ G.hom` as morphisms
> `G ⊗ G ⟶ Spec k` (both compositions equal the structure map of
> `G ⊗ G` in `Over (Spec k)`). Translating to the presheaf level
> via Mathlib's `Scheme.Hom.toRingCatSheafHom` functorial:
> `(ψ.app X) ∘ (φ_G.app X)` factors through the source-presheaf
> morphism `φ_LHS.app (snd⁻¹ X)` (where `φ_LHS` is the compatibility
> morphism for the structure map of `(G ⊗ G)` as a `G`-scheme via
> `pr_1`). By construction of the pointwise derivation, the universal
> Kähler differential vanishes on the image of the source-presheaf
> morphism (this is the `Derivation.d_app` law of `KaehlerDifferential.D`
> at `Mathlib/Algebra/Category/ModuleCat/Differentials/Basic.lean`).
>
> Concretely, the Lean closure should chase the equality
> `fst.left ≫ G.hom = snd.left ≫ G.hom` via the `Over (Spec k)`
> structural identities (`Over.comp_left`, `Over.toUnit_left`, and
> the universal property of the binary product `G ⊗ G`), then apply
> the algebra-side `ModuleCat.Derivation.d_app` to discharge the
> vanishing.

### Edit 3: Add a `% NOTE iter-138:` paragraph spelling out the d_map closure recipe

Insert after Edit 2, spelling out the **mathematical** d_map closure
recipe:

> The d_map law of the pointwise derivation requires showing, for
> each morphism `f : X ⟶ Y` of opens in `G.left.Opensᵒᵖ` and each
> `x ∈ G.left.presheaf.obj X`, the cross-open naturality square
>
>   `(d_Y).d (G.left.presheaf.map f x) = ((pushforward ψ).obj LHS).map f ((d_X).d x)`
>
> where `d_X(b) := KaehlerDifferential.D ((ψ.app X).hom b)` is the
> pointwise derivation at open `X`.
>
> This is a chase of two pieces of naturality:
> 1. **`ψ.naturality f`** (from `Scheme.Hom.c.naturality` applied to
>    the second projection `snd G G`): translates the LHS's
>    `(ψ.app Y).hom (G.left.presheaf.map f x)` into
>    `(G⊗G).left.presheaf.map (snd⁻¹.map f) ((ψ.app X).hom x)`.
> 2. **`KaehlerDifferential.map_d`** (Mathlib name
>    `CommRingCat.KaehlerDifferential.map_d`, available via
>    `relativeDifferentials'_map_d` at
>    `Mathlib/Algebra/Category/ModuleCat/Differentials/Presheaf.lean:201`):
>    the universal Kähler derivation commutes with ring-map
>    base-change, i.e. `D' (f a) = M.map f (D a)` where `D` and `D'`
>    are the universal Kähler derivations at the source and target
>    of the ring map `f`.
>
> Composing: applying `KaehlerDifferential.D _` to both sides of the
> ψ-naturality identity gives the required `d_map` equation, after
> identifying the right-hand side's
> `((pushforward ψ).obj LHS).map f` with the LHS-presheaf restriction
> `LHS.map (snd⁻¹.map f)` composed with the structural `restrictScalars`
> action of `ψ` (transparent on `.map` per
> `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:39, 86`).

### Edit 4: Add a Route (b'2) sub-paragraph to the IsIso NOTE block (around `RigidityKbar.tex:577–620`)

Currently the Routes (a) and (b) NOTE at L530–L620 describes Route
(a) chart-unfolding-helper + Route (b) inverse-direction-via-
adjunction-transpose. Iter-138 closure landed Route (b)'s derivation
construction; the IsIso of `basechange_along_proj_two_inv` is the
remaining concrete sorry, and iter-139's mathlib-analogist
returned **PROCEED with Route (b'2)** as the cheapest closure path.

Add a new sub-paragraph **after** the existing Route (b) prose
(immediately before the L632 chart-by-chart prose), inside the same
NOTE block, spelling out Route (b'2):

> **Route (b'2): local-iso check via `PresheafOfModules.toPresheaf`
> + `NatTrans.isIso_iff_isIso_app` (~195–365 LOC; per the
> `mathlib-analogist-isiso-routes-iter139` verdict).** The iso
> `IsIso (basechange_along_proj_two_inv G)` reduces to a per-open
> identification via a 5-line reflective bridge.
>
> The bridge `isIso_of_app_iso_module` (placed in
> `Cotangent/GrpObj.lean` adjacent to `basechange_along_proj_two_inv`)
> is built from two Mathlib facts: (i) the forgetful functor
> `PresheafOfModules.toPresheaf R : PresheafOfModules R ⥤ Cᵒᵖ ⥤ Ab`
> at `Mathlib/Algebra/Category/ModuleCat/Presheaf.lean:149` reflects
> isomorphisms (via the priority-100 instance
> `reflectsIsomorphisms_of_reflectsMonomorphisms_of_reflectsEpimorphisms`
> at `Mathlib/CategoryTheory/Functor/ReflectsIso/Balanced.lean:31`,
> combining `Balanced (PresheafOfModules R)` + `Faithful` →
> `ReflectsMonomorphisms` + `ReflectsEpimorphisms`); (ii)
> `NatTrans.isIso_iff_isIso_app` at
> `Mathlib/CategoryTheory/NatIso.lean:232` reduces the iso-check on
> a natural transformation to a pointwise iso-check at every object.
> The import of `Mathlib/CategoryTheory/Functor/ReflectsIso/Balanced.lean`
> must be present (transitively or directly) for the typeclass
> synthesis to succeed.
>
> With the bridge in hand, the iso check reduces to verifying that
> the per-open `ModuleCat`-morphism
> `(basechange_along_proj_two_inv G).app X`
> is an iso for every open `X`. Identifying this per-open morphism
> with `KaehlerDifferential.tensorKaehlerEquiv.symm` (from
> `Mathlib/RingTheory/Kaehler/TensorProduct.lean`) modulo the
> chart-unfolding `pullbackObjEquivTensor` (Route (a) Step 2 of the
> 5-step recipe, also load-bearing here and shared with Route (a))
> and the chart-level `Algebra.IsPushout` square (Route (a) Step 1,
> shared) discharges the goal. The companion simp lemma
> `tensorKaehlerEquiv_symm_D_tmul` handles the value identity at
> the level of `D b ↦ 1 ⊗ D b`.
>
> **Iter-140 prover gap items, in build order**:
> 1. The 5-line `isIso_of_app_iso_module` helper (verified to
>    typecheck per the iter-139 analogist consult).
> 2. The chart-level `Algebra.IsPushout`-from-affine-product helper
>    (~80–150 LOC; shared with Route (a)).
> 3. The `((pullback ψ).obj M).obj X` chart-unfolding helper
>    `pullbackObjEquivTensor` (~30–60 LOC; shared with Route (a)).
> 4. The per-open identification with `tensorKaehlerEquiv.symm`
>    (~80–150 LOC).
>
> **Mathlib API verified iter-139**: `PresheafOfModules.toPresheaf`
> (at `Mathlib/Algebra/Category/ModuleCat/Presheaf.lean:149`);
> `NatTrans.isIso_iff_isIso_app` (at
> `Mathlib/CategoryTheory/NatIso.lean:232`); `PresheafOfModules.pullback`
> (at `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pullback.lean:44`);
> `PresheafOfModules.pullbackPushforwardAdjunction` (at
> `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pullback.lean:50`);
> `KaehlerDifferential.tensorKaehlerEquiv`
> (at `Mathlib/RingTheory/Kaehler/TensorProduct.lean`).
>
> **Why Route (b'2) over Route (a)**: Route (a) requires explicitly
> constructing the forward direction `Ω_{(G⊗G)/G} → (pullback ψ).obj Ω_{G/k}`
> as well as the inverse pair, ~80–200 LOC of extra work. Route
> (b'2) uses the 5-line iso-reflection bridge to skip the forward
> direction entirely, paying instead for a slightly heavier
> per-open identification. Net savings ~50–195 LOC. Both routes
> share the heavy lifting on `pullbackObjEquivTensor` and the
> chart-level `Algebra.IsPushout`; these helpers are upstream-PR
> candidates regardless of route choice.

### Edit 5: Add `\lean{...}` blocks for the two iter-138 helpers (between `lem:GrpObj_omega_basechange_proj` at L442 and `lem:GrpObj_omega_restrict_to_identity_section` at L642)

The two iter-138 top-level Lean helpers are first-class declarations
in `Cotangent/GrpObj.lean` that carry load-bearing project content
(the three iter-140 sub-sorries all live inside or downstream of
them) but are NOT pinned in the blueprint with `\lean{...}`. Add
two dedicated lemma blocks **after** the proof block of
`lem:GrpObj_omega_basechange_proj` (i.e. starting around L640) and
**before** `lem:GrpObj_omega_restrict_to_identity_section`:

```latex
\begin{lemma}[(i.b-helper) Inverse-direction derivation for the base-change iso]
  \label{lem:GrpObj_omega_basechange_proj_inv_derivation}
  \lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_derivation}
  \uses{def:relative_kaehler_presheaf, def:GrpObj_schemeHomRingCompatibility, lem:GrpObj_omega_basechange_proj}
  Let $G : \Over\,(\Spec k)$ as in \cref{lem:GrpObj_omega_basechange_proj}, and let
  $\psi := (\Scheme.Hom.toRingCatSheafHom\,(\snd_G).left)$.hom be the compatibility
  morphism for the second projection. There is a $\varphi_G$-derivation
  $D : ((\PresheafOfModules.pushforward\,\psi).\obj\,\Omega_{(G \times_k G)/G}).\Derivation'\,\varphi_G$
  on the transparent pushforward of the left-hand-side relative cotangent
  along $\psi$, defined pointwise at each open $X$ by
  $d_X(b) := \KaehlerDifferential.D\,((\psi.\app\,X).\hom\,b)$.

  Constructed via \texttt{PresheafOfModules.Derivation'.mk} at the
  per-open level using \texttt{ModuleCat.Derivation.mk} with the
  rule above; the additive and multiplicative laws follow from
  $\psi.\app\,X$'s \texttt{RingHom}-ness composed with the
  algebra-side derivation laws of \texttt{KaehlerDifferential.D}.
  \notready
\end{lemma}

\begin{proof}
  \uses{def:relative_kaehler_presheaf, def:GrpObj_schemeHomRingCompatibility, lem:GrpObj_omega_basechange_proj}
  See the \texttt{\% NOTE iter-138:} block of
  \cref{lem:GrpObj_omega_basechange_proj}'s proof above for the
  $d_{\app}$ and $d_{\map}$ closure recipes; the additive
  and Leibniz laws are closed iter-138.
\end{proof}

\begin{lemma}[(i.b-helper) Inverse-direction morphism for the base-change iso]
  \label{lem:GrpObj_omega_basechange_proj_inv}
  \lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv}
  \uses{def:relative_kaehler_presheaf, def:GrpObj_schemeHomRingCompatibility, lem:GrpObj_omega_basechange_proj, lem:GrpObj_omega_basechange_proj_inv_derivation}
  With $G, \psi$ as above, the universal property of
  $\Omega_{G/k} = \texttt{relativeDifferentialsPresheaf}\,G.\hom$
  applied to the derivation $D$ of
  \cref{lem:GrpObj_omega_basechange_proj_inv_derivation}, then
  transposed along the
  \texttt{PresheafOfModules.pullbackPushforwardAdjunction}\,$\psi$,
  produces an inverse morphism
  \[
    \texttt{basechange\_along\_proj\_two\_inv}\,G \colon \;\;
    (\PresheafOfModules.pullback\,\psi).\obj\,\Omega_{G/k}
    \;\longrightarrow\;
    \Omega_{(G \times_k G)/G}.
  \]

  This morphism is the inverse of the iso of
  \cref{lem:GrpObj_omega_basechange_proj}; the iso property
  $\IsIso\,(\texttt{basechange\_along\_proj\_two\_inv}\,G)$ is the
  third concrete sub-sorry of \cref{lem:GrpObj_omega_basechange_proj}
  proof block (iter-140 prover target, Route (b'2) per
  \texttt{analogies/isiso-basechange-along-proj-two-inv.md}).
  \notready
\end{lemma}

\begin{proof}
  \uses{def:relative_kaehler_presheaf, def:GrpObj_schemeHomRingCompatibility, lem:GrpObj_omega_basechange_proj, lem:GrpObj_omega_basechange_proj_inv_derivation}
  Direct definition; no proof body (the construction is via
  $(\DifferentialsConstruction.isUniversal'\,\varphi_G).desc$ on
  \cref{lem:GrpObj_omega_basechange_proj_inv_derivation}'s derivation
  followed by $(\pullbackPushforwardAdjunction\,\psi).\homEquiv.\symm$).
  Sorry-free in Lean iter-138.
\end{proof}
```

(Adjust the LaTeX syntax to match the chapter's existing conventions,
e.g. `\Omega_{(G \times_k G)/G}` vs `\Omega[(G\times_k G)/G]`; consult
the existing prose at L482–L486.)

### Edit 6: Possible `sync_leanok` mis-mark documentation (informational)

`RigidityKbar.tex:491` carries `\leanok` on the proof block of
`lem:GrpObj_omega_basechange_proj`, but the Lean target has
`letI : IsIso ... := sorry` at `Cotangent/GrpObj.lean:624`. The
`sync_leanok` script may have mis-handled this `letI` pattern.

**Do NOT add or remove the `\leanok` yourself** (that is `sync_leanok`'s
territory; agents do not edit `\leanok` per the project's marker
vocabulary). Add a `% NOTE iter-139:` comment ABOVE the existing
`\leanok` line flagging the mis-mark concern for the iter-139 plan
agent's `doctor`-skill consult (record only — no edit to the
`\leanok` itself).

## Out of scope

- **DO NOT modify** chart-by-chart prose at L632–L638 — that is
  preserved as informal motivation per the iter-137 NOTE block.
- **DO NOT modify** the iter-135 / iter-137 / iter-138 NOTE blocks
  already in place — they are historical record.
- **DO NOT modify** other lemma blocks (`lem:GrpObj_cotangentSpace`,
  `lem:GrpObj_shearMulRight`, `lem:GrpObj_omega_restrict_to_identity_section`,
  `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`,
  `lem:GrpObj_mulRight_globalises`, `def:GrpObj_schemeHomRingCompatibility`,
  `thm:rigidity_over_kbar`).
- **DO NOT touch the `\leanok` marker at L491** (sync_leanok
  territory).
- **DO NOT edit** `AlgebraicJacobian_Cotangent_GrpObj.tex` (the
  pointer chapter); the plan agent will handle that update directly
  (it's a 2-bullet enumeration addition).
- **DO NOT add new chapters or `\input{}` lines** in this dispatch.

## References

- `analogies/isiso-basechange-along-proj-two-inv.md` (iter-139
  analogist verdict on Route (b'2) — full route comparison + LOC
  table + verified Mathlib API names; **read this directly** for
  Edit 4's Route (b'2) content).
- `analogies/kaehler-tensorequiv-presheafpullback.md` (iter-137
  analogist 5-step recipe; the parent context for Routes (a) and
  (b); read for Edit 1 background).
- `analogies/mulright-globalises-cotangent.md` (Decision 2 — the
  parent decomposition that makes piece (i.b) load-bearing).
- `analogies/phi-compatibility-morphisms.md` (the iter-135
  compatibility-morphism verdict pinning `Scheme.Hom.toRingCatSheafHom`).
- The iter-138 Lean docstring at
  `AlgebraicJacobian/Cotangent/GrpObj.lean:476–525` (and the per-
  declaration docstrings at L526–L546, L587–L595) — read these
  directly for the substantive d_app + d_map + IsIso closure
  recipes the Lean side records.
- The iter-138 task result at
  `task_results/Cotangent_GrpObj.lean.md` (the prover's own report
  of the Route (b) skeleton closure + 3 sub-sorry breakdown).

## Expected outcome

After your edits, `RigidityKbar.tex` should:

- Carry the iter-138 closure shape recorded in a `% NOTE iter-138:`
  block.
- Carry detailed mathematical (NOT Lean-syntactic) closure recipes
  for d_app and d_map, sufficient that an iter-140 prover can
  attack each sub-sorry without re-reading the Lean docstring or
  any external analogist file.
- Carry the Route (b'2) sub-paragraph in the IsIso NOTE block,
  including the 5-line bridge and the iter-140 build order.
- Carry two new `\lean{...}` blocks pinning
  `basechange_along_proj_two_inv_derivation` and
  `basechange_along_proj_two_inv`.
- Carry the `% NOTE iter-139:` informational flag on the
  `\leanok` mis-mark concern at L491.
- Preserve every other piece of the chapter verbatim.
- Compile as part of the blueprint build (Edit 1–6 must not break
  any LaTeX syntax; if you introduce new commands, add them to
  `blueprint/src/macros/common.tex`, but prefer existing ones).

In your report, list:
- The line ranges of each of the 6 edits.
- Any places where you noticed a contradiction with the iter-138
  Lean code (note for plan agent; do NOT modify the Lean side).
- Whether you needed to add macros to `common.tex` (mention which).
- Whether the iter-137/iter-138 NOTE blocks should be condensed or
  preserved verbatim (default: preserve; plan agent decides
  consolidation iter-140+).
