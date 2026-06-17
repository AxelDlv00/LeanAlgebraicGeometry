# Blueprint-writer directive — chapter `Picard_TensorObjSubstrate.tex` (iter-227)

You edit ONLY `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. Three precise,
additive edits. Do NOT touch any other block, do NOT add/remove `\leanok` or `\mathlibok`
(the deterministic `sync_leanok` phase owns `\leanok`).

## Strategy context (the slice that matters)

This chapter blueprints the by-hand commutative-group law on iso-classes of locally-trivial
(invertible) `O_X`-modules under tensor product (the substrate for the relative Picard sheaf
`Pic_{C/k}`). The remaining mathematical work is the "descent re-route": the ⊗-inverse
(`lem:tensorobj_inverse_invertible`, `exists_tensorObj_inverse`) and the associator
(`tensorObj_assoc_iso`) are built by **gluing canonical local trivialising isomorphisms** (obtained
from the already-closed `tensorObj_restrict_iso` + `tensorObj_unit_iso`) into a global morphism of
sheaves of modules, then concluding it is a global iso because "being an isomorphism is local."
This route was confirmed by a Mathlib-idiom consult (analogist ts226descent) to genuinely AVOID the
abandoned tensor-stalk commutation ("d.2"); every bridge rests on an existing Mathlib primitive.

Two of the three descent bridges are now realised in Lean but are NOT yet named blocks in this
chapter (they appear only as inline phrases inside `rem:dual_discharges_inverse` and the proof of
`lem:tensorobj_inverse_invertible`). A per-file blueprint check flagged this: the bridges need named,
trackable lemma blocks so `sync_leanok` can pin them and the prover has an explicit target. All three
edits below are project-bespoke category-theory infrastructure built on cited Mathlib primitives —
treat them as **Archon-original blocks** (no external `% SOURCE:`/`% SOURCE QUOTE:` lines required;
the blocks stand on their own statement + sketch, naming the Mathlib primitives in prose). If while
drafting you decide a Stacks "gluing morphisms of sheaves" tag (e.g. the sheaf-Hom/descent section)
would strengthen a citation, you MAY dispatch a reference-retriever (your write-domain includes
`references/**`) and quote it verbatim — but this is optional; these are infrastructure lemmas.

## Edit 1 — add the `archon:covers` annotation

Near the very top of the file, just after `\label{chap:Picard_TensorObjSubstrate}` (mirroring how
`Picard_QuotScheme.tex` does it on its line 3), add the line:

    % archon:covers AlgebraicJacobian/Picard/TensorObjSubstrate.lean

(This declares the chapter as the consolidated blueprint for that Lean file, which it already is in
practice.)

## Edit 2 — named block for the "locally-iso ⇒ global iso" B-connector

Add a new `\begin{lemma} ... \end{lemma}` + `\begin{proof} ... \end{proof}` block inside the dual
infrastructure section `\label{sec:tensorobj_dual_infra}` (place it just BEFORE
`rem:dual_discharges_inverse`, i.e. before line ~2775, since that remark already invokes "being an
isomorphism is local"). Specifications:

- `\label{lem:isiso_of_isiso_restrict}`
- `\lean{AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict}`
- `\uses{}` — none required (it is a standalone locality principle); you may leave `\uses{}` absent.
- Human title: `[Local isomorphisms of O_X-modules glue to a global isomorphism]`.
- Statement (project notation): Let `X` be a scheme and `phi : M --> N` a morphism in `X.Modules`
  (= `SheafOfModules X.ringCatSheaf`). Suppose given, for every point `x` of `X`, an open
  neighbourhood `U x` of `x` such that the restriction of `phi` to `U x` (i.e.
  `(Scheme.Modules.restrictFunctor (U x).i).map phi`) is an isomorphism. Then `phi` is an
  isomorphism.
- Proof sketch (the route that was formalised, stalkwise): "being an isomorphism" of a morphism of
  sheaves of `O_X`-modules can be checked on stalks. For each point `x`, choose a preimage `x'` of
  `x` in `U x` under the open immersion `(U x).i`. The restriction of `phi` to `U x` is an
  isomorphism by hypothesis, hence so is its image under any functor; transporting along the natural
  isomorphism "restriction commutes with stalks" (`restrictStalkNatIso`) shows the stalk of `phi` at
  `x` (as a morphism of the underlying sheaves of abelian groups) is an isomorphism. As this holds at
  every point and a morphism of sheaves of abelian groups with isomorphism stalks is an isomorphism
  (`isIso_of_stalkFunctor_map_iso` on `TopCat.Sheaf`), the underlying ab-sheaf morphism is an iso;
  the forgetful functor `Scheme.Modules.toPresheaf` reflects isomorphisms, so `phi` itself is an iso.
  Name in prose the Mathlib pieces used: stalkwise iso-detection for sheaves, the
  restriction-commutes-with-stalks natural iso, and reflection of isos along the forgetful functor.

## Edit 3 — named block for the A-bridge (SheafOfModules morphism descent)

Add a second new `\begin{lemma} ... \end{lemma}` + `\begin{proof}` block, also inside
`sec:tensorobj_dual_infra` (place it right AFTER the B-connector block of Edit 2, before
`rem:dual_discharges_inverse`). This is the genuinely-novel infrastructure step the prover will build
next, so the sketch must be detailed enough to formalise. Specifications:

- `\label{lem:sheafofmodules_hom_of_local_compat}`
- `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}`  (a forward pin; the Lean declaration
  does not exist yet — that is expected and correct for a not-yet-formalised block.)
- `\uses{}` — none strictly required; you may reference `lem:tensorobj_restrict_iso` if you cite it
  in the sketch, otherwise leave absent.
- Human title: `[Compatible local morphisms of O_X-modules glue to a global morphism]`.
- Statement (project notation): Let `X` be a scheme, `M N : X.Modules`, and `{U_i}` an open cover of
  `X`. Suppose given for each `i` a morphism `f_i : M|_{U_i} --> N|_{U_i}` such that for all `i, j`
  the restrictions of `f_i` and `f_j` to `U_i ∩ U_j` agree. Then there is a (unique) global morphism
  `f : M --> N` in `X.Modules` whose restriction to each `U_i` is `f_i`.
- Proof sketch (the intended formalisation route): A morphism of sheaves of `O_X`-modules is, in
  particular, a morphism of the underlying sheaves of abelian groups that is additionally
  `O_X`-linear sectionwise. (i) GLUE THE UNDERLYING AB-SHEAF MORPHISM. Forget `M, N` to their
  underlying sheaves of abelian groups via the faithful additive functor
  `SheafOfModules.toSheaf`. The hom-presheaf `U \mapsto Hom(M|_U, N|_U)` of sheaves of abelian groups
  is itself a sheaf (the morphism-gluing / "hom into a sheaf is a sheaf" principle,
  `Presheaf.IsSheaf.hom` / `sheafHomSectionsEquiv` in `CategoryTheory.Sites.SheafHom`). Hence the
  compatible family `(f_i)` — being a compatible family of sections of this hom-sheaf over the cover
  — amalgamates to a unique global section, i.e. a global morphism `g` of the underlying ab-sheaves
  restricting to each `f_i`. (ii) PROMOTE TO `O_X`-LINEAR. The `O_X`-linearity equation
  `g(r · m) = r · g(m)` is a sectionwise identity; it holds on each `U_i` (because `f_i` is a module
  morphism) and the two sides are sections of a separated presheaf agreeing on a cover, so it holds
  globally. Package `g` together with this global linearity as a morphism `f : M --> N` in
  `X.Modules` (`PresheafOfModules.homMk`). Uniqueness and the restriction property are inherited from
  the ab-sheaf amalgamation. Name in prose the Mathlib primitives: the hom-sheaf/descent statement in
  `CategoryTheory.Sites.SheafHom`, the faithful additive `SheafOfModules.toSheaf`, and
  `PresheafOfModules.homMk`. Note explicitly (one sentence) that this descent step computes NO tensor
  stalk — it is a statement about morphisms of sheaves — and so does not re-enter the abandoned
  tensor-stalk commutation.

## Out of scope (do NOT do)
- Do NOT edit `rem:dual_discharges_inverse`, `lem:dual_isLocallyTrivial`,
  `lem:tensorobj_inverse_invertible`, or any other existing block beyond inserting the two new blocks
  and the one `archon:covers` line.
- Do NOT add `\leanok`/`\mathlibok` anywhere.
- Do NOT rename or re-sign any existing `\lean{...}` pin.
- Keep both new blocks self-contained and at textbook rigor; no Lean tactic syntax in the prose.

## Report
List the exact labels/`\lean{}` pins you added and where (section + approximate line), and whether
you dispatched a reference-retriever (if so, which tag and where you quoted it).
