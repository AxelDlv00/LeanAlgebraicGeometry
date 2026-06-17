# blueprint-writer directive — chapter Picard_TensorObjSubstrate.tex (slug: d2wiring)

## Strategy context (the slice that matters)

The d.2 stalk–tensor commutation isomorphism `PresheafOfModules.stalkTensorIso`
(`lem:stalk_tensor_commutation`, `(A ⊗ᵖ B)_x ≅ A_x ⊗_{R_x} B_x`) is now COMPLETE and
axiom-clean. The next critical-path target is the associator's single open obligation,
the lemma `lem:islocallyinjective_whiskerleft_via_stalk`
(`\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}`), which currently has a thin
proof sketch and an open `sorry` in Lean (file `Picard/TensorObjSubstrate/Vestigial.lean`).
Closing it makes `tensorObj_assoc_iso` sorry-free → the by-hand `CommGroup`.

The Lean file `Picard/TensorObjSubstrate/Vestigial.lean` is NOT currently listed in this
chapter's `% archon:covers` lines (which list only `TensorObjSubstrate.lean` and
`TensorObjSubstrate/StalkTensor.lean`). The whiskering lemma it contains is already blueprinted
in THIS chapter, so the file should be added to the coverage declaration.

## Required edits

### 1. Coverage declaration
Add `AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean` to the `% archon:covers`
lines at the top of the chapter (one more `% archon:covers ...` line, matching existing style).

### 2. Expand the proof sketch of `lem:islocallyinjective_whiskerleft_via_stalk` (around line 2103–2141)

The current proof sketch correctly names the two-step idea (d.1: J.W ⟺ stalkwise iso; d.2:
identify the whiskered stalk with id ⊗ g_x) but is too thin for formalization. Rewrite the
`\begin{proof}` body to spell out THREE concrete movements, in the project's notation:

(a) **The d.1-bridge (site-level J.W ⟹ stalkwise isomorphism on `Opens X`).** A morphism
`g` of presheaves of modules over the topological site `Opens X` with `(toPresheaf).map g ∈ J.W`
has, at every point `x`, an isomorphism of `Ab`-stalks `(stalkFunctor Ab x).map ((toPresheaf).map g)`.
The Mathlib ingredients are: `CategoryTheory.GrothendieckTopology.W.isLocallyInjective`
(J.W → locally injective) and the corresponding local surjectivity, together with the TopCat
stalk criteria `TopCat.Presheaf.app_injective_iff_stalkFunctor_map_injective` and the
locally-surjective-on-stalks characterisation; equivalently, on the topological site one may use
`TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso` after identifying local bijectivity with a
sheaf-isomorphism on the associated sheaves. State this as a NAMED sub-lemma so it can be pinned:

  \begin{lemma}[d.1-bridge: locally bijective implies stalkwise iso]
    \label{lem:W_implies_stalkwise_iso}
    \lean{PresheafOfModules.isIso_stalkFunctor_map_of_W}   % suggested Lean name; prover may adjust
    \uses{lem:stalk_linear_map}
    For a morphism g of presheaves of R-modules over the small site Opens X with
    (toPresheaf).map g ∈ J.W, the induced Ab-stalk map at every x is an isomorphism.
  \end{lemma}
with a short proof sketch citing the Mathlib lemmas above.

(b) **B-argument naturality of `stalkTensorIso` (NEW helper, the genuinely new ingredient).**
`stalkTensorIso` is constructed for fixed A, B. To identify the whiskered stalk we need that it
is natural in the SECOND tensor factor: for g : M → N, the square relating
`(A ⊗ᵖ g)_x` (the stalk of the whiskered map) to `LinearMap.lTensor A_x (stalkLinearMap g x)`
commutes, i.e. `stalkTensorIso A N ∘ (id_A ⊗ g)_x = lTensor A_x g_x ∘ stalkTensorIso A M`.
State this as a NAMED sub-lemma:

  \begin{lemma}[B-naturality of the stalk–tensor comparison]
    \label{lem:stalk_tensor_commutation_naturality_right}
    \lean{PresheafOfModules.stalkTensorIso_naturality_right}   % suggested; prover may adjust
    \uses{lem:stalk_tensor_commutation, lem:stalk_linear_map}
    For g : M → N, under stalkTensorIso the stalk of A ◁ g is identified with
    LinearMap.lTensor A_x (stalkLinearMap g x).
  \end{lemma}
Proof sketch: both sides are determined on germ generators germ(a) ⊗ germ(m) by the germ
characterisations `stalkTensorLinearMap_germ_tmul` / `stalkTensorRev_germ_tmul` and
`stalkLinearMap_germ`; check the identity there and extend by `TensorProduct.induction_on`.

(c) **Conclude.** Since each `g_x` is an iso (by (a)) and `stalkLinearMap g x` is then a linear
equivalence (`stalkLinearEquivOfIsIso`, already built), `LinearMap.lTensor A_x (g_x)` is an iso
(tensoring an equivalence by the identity — `LinearEquiv.lTensor`, flatness-free). By (b),
`(A ◁ g)_x` is therefore an iso for every x; by the d.1-bridge (a) in reverse, `A ◁ g ∈ J.W`,
hence is J-locally injective (`GrothendieckTopology.W.isLocallyInjective`). No flatness, no local
triviality; F (= A) arbitrary.

Add a short note: the Lean lemma is stated over a general site J but is only ever consumed at
`R := X.presheaf` (the topological site of a scheme); the proof specialises to `Opens X` where
stalks exist. The declaration is UNPROTECTED, so the prover may re-sign it to the topological
site if needed; its only consumers `W_whiskerLeft_of_W` / `W_whiskerRight_of_W` and ultimately
`tensorObj_assoc_iso` already instantiate at `X.presheaf`.

### 3. (Optional, if natural) note the consumer repoint
`thm:rel_pic_addcommgroup_via_tensorobj` still `\uses` the locally-trivial group; a future edit
repoints it to `thm:pic_commgroup` once the carrier group lands. You need not change it now;
just leave the existing standing note intact.

## Out of scope
- Do NOT touch the StalkTensor section (`sec:tensorobj_stalk_tensor`) — d.2 is done and correct.
- Do NOT add/remove `\leanok` or `\mathlibok` markers anywhere (sync_leanok / review own those).
- Do NOT delete the off-path duplicate `lem:islocallyinjective_whisker_of_W` (a separate
  deferred cleanup); just keep the live lemma's sketch accurate.
- Keep the proof sketch MATHEMATICAL — no Lean tactic strings.

## References
The d.1-bridge cites Mathlib stalk lemmas (Mathlib.Topology.Sheaves.Stalks,
Mathlib.CategoryTheory.Sites.{LocallyBijective,LocallyInjective}). No external paper needed; if
you want to cite the stalkwise-localizer principle, Stacks tag 01CR / the conservative-family
characterisation suffices (you may use references/stacks-modules.tex if a verbatim quote helps,
but this lemma is Archon-original assembly, so a SOURCE QUOTE is not mandatory).
