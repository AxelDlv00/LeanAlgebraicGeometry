# Blueprint-writer directive — bw254

## Chapter to edit
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (ONLY this chapter).

## Context (self-contained)
This chapter blueprints the Picard tensor-substrate, including the A-bridge lemma
`lem:sheafofmodules_hom_of_local_compat` (Lean: `AlgebraicGeometry.Scheme.Modules.homOfLocalCompat`),
which glues a compatible family of local `𝒪_X`-module morphisms `f i : M|_{U_i} ⟶ N|_{U_i}` over an
open cover `{U_i}` (with `⨆ U_i = ⊤`) into a single global morphism `M ⟶ N`.

A formalization audit (iter-253) established that the chapter's proof of **sub-step (a)** (the
`IsCompatible`/cocycle bridge, currently lines ~5801–5825) describes a bridge that **does not match a
satisfiable Lean signature** and must be corrected. This directive is ONLY about correcting that proof
sub-step (and one minor add). Do NOT touch any other lemma's statement or proof.

## The mathematical correction required (must-fix)

The current prose says the overlap-agreement hypothesis is a **heterogeneous equality (`HEq`)** between
the two double-restrictions `(f_i)|_{U_i∩U_j}` and `(f_j)|_{U_i∩U_j}`, asserting the two underlying
types are "propositionally equal but not definitionally equal", and that the bridge collapses the
route-difference via `Subsingleton.elim`.

This is **mathematically wrong for the construction in play**: the two restriction morphisms are images
of the pullback-of-modules functor along two *different* slice-restriction maps, landing in objects that
are **sheafifications of pullback presheaves along different morphisms** — these objects are only
**isomorphic** (via a nontrivial comparison iso), NOT propositionally equal. Hence the `HEq` cannot be
eliminated into an honest equation (no `eq_of_heq`/`HEq.elim`/`Subsingleton.elim` applies; the
`Subsingleton.elim` collapse only handles the *thin-poset* route-difference, never the genuinely
distinct `Ab`-hom-set section maps), and the hypothesis is **not even satisfiable** by a caller.

**Rewrite sub-step (a)** so the compatibility hypothesis is stated in the **honest sectionwise form**:

> For all indices `i, j` and every open `V` with `V ≤ U_i` and `V ≤ U_j`, the two section maps
> `(f_i).app(V)` and `(f_j).app(V)` agree as morphisms in the single, fixed abelian-group hom-type
> `M(V) ⟶ N(V)` (the value of the hom-presheaf `ℋom(M,N)` at `V`).

With this phrasing the bridge to `IsCompatible` is **direct**: restricting the local section
`localSection i` to the overlap `U_i ⊓ U_j` evaluates sectionwise (by
`lem:scheme_modules_hom_local_section`, whose `app` field is exactly `(f_i).app` conjugated by the
canonical `eqToHom` identifications) to `(f_i).app` on the relevant open; the sectionwise hypothesis
then equates the two middle terms directly, and the only remaining identification — that the two
`eqToHom`-conjugation routes through the thin poset `(Opens X)ᵒᵖ` agree — is the genuine, correct use of
`Subsingleton.elim`. State explicitly that the sectionwise hypothesis is what any caller can actually
produce (two local morphisms that literally agree on overlaps), in contrast to the unsatisfiable `HEq`
form.

Keep the prose at textbook rigor, in the project's notation (no Lean tactic strings, no `HEq`/`eqToHom`
as the *content* — you may name `eqToHom`/`Subsingleton.elim` as the mechanical identifications, as the
current text already does, but the SUBSTANTIVE hypothesis must be the sectionwise equality). Sub-steps
(b) and (c) are already correct — leave them. Do NOT add or remove `\leanok`/`\mathlibok` markers.

## Minor add (same chapter)
`lem:scheme_modules_hom_local_section` currently has no `\begin{proof}...\end{proof}` block (it is
statement-only). Add a short proof block describing how the local section's `app` field is built from
`(f_i).app` by `eqToHom`-conjugation and how its naturality is the `Subsingleton.elim` collapse of the
two thin-poset diagram edges (the Lean proof exists and is axiom-clean; describe the math, not the
tactics).

## No new sources needed
This is a correction of existing project-bespoke prose (the A-bridge is an Archon-original gluing
construction, no external citation block). You do not need to retrieve references. If you find you DO
need a source for the sheaf-gluing fact (`existsUnique_gluing`), it is standard sheaf theory — cite
Stacks "Sheaves on Spaces" only if a block already carries a source line; otherwise leave it as the
project-bespoke construction it is.

## Out of scope
- Do NOT touch `lem:dual_restrict_iso`, `lem:dual_unit_iso`, `lem:dual_isLocallyTrivial`, or any D1′/D3′
  comparison-iso lemmas.
- Do NOT change any `\lean{...}` hint or `\label{...}`.
- Do NOT add markers.

## Report
In your report, quote the before/after of sub-step (a) and confirm the new hypothesis is the sectionwise
form. Flag any "Strategy-modifying findings" if the correction surfaces a deeper issue.
