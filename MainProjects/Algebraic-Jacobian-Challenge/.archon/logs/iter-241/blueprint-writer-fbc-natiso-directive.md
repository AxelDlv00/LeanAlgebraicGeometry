# blueprint-writer directive — `Cohomology_FlatBaseChange.tex` (iter-241)

## Scope (one chapter only)
Edit ONLY `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`. Do not touch any other chapter.

## Why (this is a must-fix gate item)
The lean-vs-blueprint checker (ts240-fbc) reported a must-fix: the `lem:pushforward_spec_tilde_iso`
proof sketch is UNDER-SPECIFIED for the one remaining open obligation. iter-240's prover broke the
4-iter `Module.compHom` carrier wall (via `algebraize`), discharged `hloc`, and reduced the whole proof
to a SINGLE residual: the **naturality-in-the-open square** of `gammaPushforwardIsoAt` (the `hsq`
obligation — that the family of open-indexed isomorphisms `{e_U}_U` commutes with the structure-sheaf
restriction maps on both sides). The prover's recommended clean route is to repackage
`gammaPushforwardIsoAt` as a genuine `NatIso` so naturality is definitional. The blueprint must specify
this before the next prover pass. The review agent already updated the `% NOTE:` on the lemma (lines
~432–440) flagging exactly this; your job is to turn that note into proper blueprint content.

## Required edits

1. **Add a naturality block for `gammaPushforwardIsoAt`.** The lemma `lem:gammaPushforwardIsoAt`
   (lines ~253–294) already ASSERTS, in prose, that "the family of these isomorphisms is natural in the
   open argument: the structure-sheaf restriction maps on the two sides commute with the isomorphisms."
   Promote this to an explicit naturality statement suitable for formalization as a functor isomorphism
   (a `NatIso` between the two open-indexed presheaves):
   - **Source presheaf** (contravariant in the open `U ⊆ Spec R`): `U ↦ Γ((Spec φ)_* N, U)`, with the
     structure-sheaf restriction maps of `(Spec φ)_* N`.
   - **Target presheaf**: `U ↦ restr_φ(Γ(N, (Spec φ)^{-1} U))`, with the restriction maps of `N`
     transported through `(Spec φ)^{-1}` and restriction of scalars along `φ`.
   - **Claim**: the family `{e_U}_U` of `R`-linear isomorphisms (`e_U` = the iso of
     `lem:gammaPushforwardIsoAt` at `U`) is a NATURAL isomorphism of these two presheaves — i.e. for an
     inclusion `U' ⊆ U` the square

       ```
         Γ((Spec φ)_* N, U)  --e_U-->  restr_φ Γ(N, V)
              | res                          | res
         Γ((Spec φ)_* N, U') --e_U'-> restr_φ Γ(N, V')
       ```
     commutes, where `V = (Spec φ)^{-1} U`, `V' = (Spec φ)^{-1} U'`.
   - State WHY it holds (the proof you already give in the `gammaPushforwardIsoAt` proof block: every
     constituent of `e_U` is either a structure-sheaf restriction map or conjugation by a fixed ring
     map, and both commute with further restriction along an inclusion of opens — so the square is the
     composite of the three component-naturality squares: the inv-naturality of the
     `restrictScalarsComp'` reconciliation, the `eqToHom`-naturality of the top-open ring equation, and
     the hom-naturality of the `restrictScalarsComp'` for `φ`).
   - Do NOT prescribe a Lean declaration name or pin a `\lean{...}` you are not sure exists — describe
     the mathematical statement so the prover can realize `gammaPushforwardIsoAt` as a `NatIso` (e.g.
     via `NatIso.ofComponents` of the per-open `e_U`). You MAY suggest a `\label`
     (e.g. `lem:gammaPushforwardIsoAt_naturality`) for cross-reference. Leave it UNPINNED if no Lean
     decl exists yet — the prover will add the decl and a later sync handles the marker.

2. **Revise the `lem:pushforward_spec_tilde_iso` proof sketch** (the "three movements" beginning ~line
   528, especially movement (1) and the `hloc` construction ~lines 514–528 and the naturality discussion
   ~lines 588–599) so that:
   - it records the carrier-wall resolution as DONE: `hloc(a)` is discharged by `algebraize`-installed
     `Algebra R R'` / `IsScalarTower` instances feeding `lem:powers_restrictScalars`
     (`lem:tildeRestriction_isLocalizedModule` supplies the `R'`-side localization) — the earlier "sole
     difficulty = structure-sheaf smul carrier wall" framing is stale and should be removed/updated;
   - it names the SINGLE remaining obligation precisely: each per-`a` `hloc(a)` follows from the
     `⊤`-level localization plus the open-naturality of `gammaPushforwardIsoAt` at `U = D(a)`
     (movement (1)'s `e_{D(a)}`), via the naturality block added in (1) — so NO hand-proved
     section-level square per individual `a`;
   - `\uses{}` is updated to include the new naturality block label.
   - Replace the review's `% NOTE:` (lines ~432–440) content with the now-specified route, OR leave a
     short pointer; do not leave the "UNDER-SPECIFIED — a blueprint-writer must add…" wording once you
     have added the block (it would be stale).

## Out of scope
- Do NOT modify `lem:pushforward_spec_tilde_iso_conditional`, `lem:powers_restrictScalars`,
  `lem:tildeRestriction_isLocalizedModule` statements (only their cross-references if needed).
- Do NOT touch `flatBaseChange_pushforward_isIso` / `affineBaseChange_pushforward_iso` proof sketches
  beyond what cross-references require.
- Do NOT add/remove `\leanok` or `\mathlibok`.
- Keep all existing Stacks/EGA SOURCE QUOTE comments byte-intact.

You have `references/**` in your write-domain in case you need to confirm a Stacks tag, but this is a
specification-tightening pass on existing project-bespoke infrastructure; no new source is expected.
