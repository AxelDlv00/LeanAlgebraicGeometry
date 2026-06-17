# Blueprint Writer Directive

## Slug
a1c-relpic

## Target chapter
`blueprint/src/chapters/Picard_RelPicFunctor.tex` (NEW)

## Lean file
`AlgebraicJacobian/Picard/RelPicFunctor.lean` (NEW — does not exist yet).

Add `% archon:covers AlgebraicJacobian/Picard/RelPicFunctor.lean` at top.

## Strategy context

Route A.1.c — the relative Picard presheaf and its étale-sheafification. Gated on A.1.a (`RelativeSpec` — chapter on disk) + A.1.b (line-bundle pullback — chapter on disk). ~300-500 LOC, ~2-4 iters.

This wires together the previous two pieces into the functor whose representability is the goal of A.2.c (the FGA Pic representability assembly).

## Required content

### Definition: relative Picard presheaf `Pic^♯_{C/k}`
For a smooth proper geometrically irreducible curve `C/k`, define the presheaf
$$\mathrm{Pic}^\sharp_{C/k} : (\mathrm{Sch}/k)^{\mathrm{op}} \to \mathbf{Set}, \qquad T \mapsto \mathrm{Pic}(C_T) / \pi^*\mathrm{Pic}(T),$$
where `C_T := C ×_k T`, `π : C_T → T` is the projection, and `π^* : Pic(T) → Pic(C_T)` is the pullback line-bundle map (the A.1.b construction).

Add `\uses{thm:line_bundle_pullback}` to wire in the previous chapter's pin.

### Definition: étale sheafification of `Pic^♯`
The Kleiman §4 functor: `Pic_{C/k} := (Pic^♯_{C/k})^\sim` where `~` is étale sheafification. Cite Kleiman §4 verbatim.

When `k` is algebraically closed, the étale sheafification step is trivial (`Pic^♯ = Pic` as functors). For general `k`, it's necessary because étale-locally a line bundle becomes trivializable.

### Lemma: functoriality of `Pic^♯`
For a morphism `g : T' → T` in `Sch/k`, the pullback `g^* : Pic^♯(T) → Pic^♯(T')` is well-defined: pullback line bundles on `C_T → C_{T'}` modulo pullbacks from `T → T'` lift to a map of quotients.

### Lemma: group structure descends
`Pic(C_T)` is an abelian group (tensor product of line bundles); the subgroup `π^*Pic(T)` is well-defined because it's the image of an abelian group homomorphism. Hence the quotient `Pic^♯(T)` is an abelian group.

### Theorem: `Pic^♯` is a group-valued presheaf
The data above makes `Pic^♯_{C/k}` a functor `(Sch/k)^op → Ab`.

### Theorem: étale-sheafification preserves group structure
Mathlib `CategoryTheory.Sheafification` preserves abelian-group structure (this should be cited from Mathlib — verify via `WebFetch` of the relevant docstring or by `lean_local_search`). If absent in Mathlib, flag as a project-side sub-build.

### Lean signature targets

- `def:rel_pic_sharp` → `AlgebraicGeometry.Scheme.PicSharp`
- `def:rel_pic_etale_sheafification` → `AlgebraicGeometry.Scheme.PicScheme`
- `lem:rel_pic_sharp_functorial` → `AlgebraicGeometry.Scheme.PicSharp.functorial`
- `lem:rel_pic_sharp_groupoid` → `AlgebraicGeometry.Scheme.PicSharp.addCommGroup`
- `thm:rel_pic_sharp_presheaf` → `AlgebraicGeometry.Scheme.PicSharp.presheaf`

## Required citations

Read verbatim from:
- `references/kleiman-picard.pdf` §4 (Construction of the Picard functor). Search the contents — the relevant statement is "Definition 9.2.2" or near (the chapter pre-introduces the relative Picard functor before stating the existence theorem).
- `references/stacks-coherent.md` for any étale sheafification tag relevant.

Per blueprint citation rules, each block needs `% SOURCE:` + `% SOURCE QUOTE:` + visible `\textit{Source: ...}`.

## Out of scope

- Do NOT write the Lean file.
- Do NOT add `\leanok` / `\mathlibok`.
- Do NOT touch `content.tex`.
- Do NOT scope into representability (that's A.2.c's chapter).

## Verification

`\input{...}` is the plan agent's job.

## Report format

Standard. Flag if `Pic^♯` requires Mathlib infrastructure that doesn't exist at the current pinned commit.
