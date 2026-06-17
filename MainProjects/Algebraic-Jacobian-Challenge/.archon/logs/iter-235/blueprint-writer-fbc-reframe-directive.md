# Blueprint-writer directive — iter-235 — FlatBaseChange affine reframe + the single Mathlib-absent brick

## Chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

## Context (self-contained)
A mathlib-analogist consult (verified against current Mathlib; persistent rationale in
`analogies/fbc-dict.md` — read it) found that the affine reduction of this chapter was framed at the
wrong altitude and that the Lean statements were missing a hypothesis. Three corrections must be reflected
in the prose. Do NOT add/remove any `\leanok`/`\mathlibok` markers (sync_leanok/review own those).

### Correction 1 — the statements require quasi-coherence (soundness)
Both `lem:affine_base_change_pushforward` (`\lean{…affineBaseChange_pushforward_iso}`) and
`thm:flat_base_change_pushforward` (`\lean{…flatBaseChange_pushforward_isIso}`) are about a
quasi-coherent `\(\mathcal F\)` (the chapter title already says so), but the Lean signatures took an
arbitrary `F : X.Modules`. The Lean decls are being amended THIS iter (refactor) to carry
`[F.IsQuasicoherent]` (Mathlib typeclass `SheafOfModules.IsQuasicoherent`; `tilde M` carries the
instance). Update each statement block's prose to state explicitly that `\(\mathcal F\)` is assumed
quasi-coherent and that this hypothesis is essential (over an affine open a general module is not
`\(\widetilde M\)`, so the affine computation needs it). Keep the existing verbatim Stacks
`% SOURCE QUOTE` blocks byte-for-byte intact — they already say "quasi-coherent".

### Correction 2 — reframe the affine lemma's proof around `tilde` full-faithfulness
Replace the affine lemma's proof reframe (and the stale `% NOTE:` at ~lines 209–216 describing a
"missing affine dictionary … Mathlib gap") with the consult's correct reduction. The corrected sketch:
- After the locality first reduction (`lem:modules_isIso_iff_affineOpens`) and localizing to
  `\(S=\Spec R,\ S'=\Spec R',\ X=\Spec A,\ \mathcal F=\widetilde M\)`, the base-change map is a morphism
  `\(\alpha\)` of quasi-coherent `\((\Spec R')\)`-modules.
- `\(\mathrm{tilde}\)` (the functor `\(\mathrm{ModuleCat}\,R' \to (\Spec R').\mathrm{Modules}\)`) is
  FULLY FAITHFUL with essential image the quasi-coherent modules, and its counit
  `\(\mathrm{fromTilde}\Gamma\)` is an isomorphism exactly on quasi-coherent modules
  (`isIso_fromTildeΓ_iff`). Hence for `\(\alpha\)` between quasi-coherent modules, counit naturality
  (`fromTildeΓNatTrans`) gives `\(\mathrm{IsIso}\,\alpha \iff \mathrm{IsIso}(\mathrm{moduleSpec}\Gamma(\alpha))\)`,
  reducing the goal to `\(\mathrm{IsIso}\)` of a CONCRETE `\(\mathrm{ModuleCat}\,R'\)` map.
- That concrete map is the `\(R'\)`-linear base-change comparison, and the claim closes by the
  associativity / cancellation isomorphism `\((R'\otimes_R A)\otimes_A M \cong R'\otimes_R M\)`
  (`TensorProduct.AlgebraTensorModule.cancelBaseChange`, present in Mathlib, no flatness).
- State that this reframe avoids ALL section-level `\(\mathrm{SMul}\)`/`\(\mathrm{Module}\)`-instance
  plumbing (the iter-234 instance wall was a wrong-altitude symptom). As construction hints (in prose,
  no Lean tactics): the ring map underlying the pushforward at `\(\top\)` is `\(f.\mathrm{appTop}\)`
  (conjugate to `\(\varphi\)` for `\(f=\Spec.map\,\varphi\)` by `ΓSpecIso_inv_naturality`);
  `\((\Spec.map\,\varphi)^{-1}\top=\top\)` holds definitionally (`Scheme.preimage_top`); and any residual
  `\(\mathrm{ModuleCat}\)`-level scalar identity is discharged by materialising the action with
  `\(\mathrm{Module.compHom}\)`/`\(\mathrm{IsScalarTower}\)` as Mathlib's own `Tilde.lean` does.

### Correction 3 — add the single Mathlib-absent brick as a named lemma
Add ONE new lemma block (in the affine section, before `lem:affine_base_change_pushforward`) stating the
genuinely Mathlib-absent ingredient the lane reduces to:
- `\label{lem:pushforward_spec_tilde_iso}` (NO `\lean{}` pin — the Lean decl is not yet built; this is the
  next FlatBaseChange prover target, to be pinned once it lands).
- `\uses{}` as appropriate (it is bespoke infrastructure; no external source proof — it is the
  affine-pushforward-of-tilde formula). You MAY cite Stacks "schemes-lemma-widetilde-pullback" as the
  classical source if you retrieve and quote it; otherwise mark it Archon-original infrastructure with no
  `% SOURCE QUOTE` (do NOT fabricate a quote).
- Statement: for a ring map `\(\varphi : R \to R'\)` and an `\(R'\)`-module `\(M\)`, there is a canonical
  isomorphism of `\((\Spec R)\)`-modules
  `\(\mathrm{pushforward}(\Spec.map\,\varphi)(\widetilde M) \cong \widetilde{(\mathrm{restrictScalars}\,\varphi)\,M}\)`.
- Note in the block that this single iso discharges BOTH (a) the global-sections / Γ-fragment comparison
  (via `\(\mathrm{moduleSpec}\Gamma\)` of the iso) AND (b) quasi-coherence of the pushforward of a tilde
  module (via closed-under-iso of the QC predicate + `\((\widetilde N)\) is quasi-coherent`), so no
  separate "pushforward preserves quasi-coherent" theorem is needed.

### Correction 4 — refresh the flat theorem's stale NOTE
The `% NOTE:` at ~lines 357–360 on `thm:flat_base_change_pushforward` may stay (the Čech/affine-cover
infrastructure for SheafOfModules IS still genuinely Mathlib-absent and the theorem IS a multi-lane build),
but update its wording so it points at `lem:pushforward_spec_tilde_iso` + the reframe as the affine input,
not the superseded "affine dictionary" framing.

## Out of scope
- Do NOT touch the `def:pushforward_base_change_map` block or the 3 locality lemmas
  (`lem:modules_isIso_*`) — they are correct and closed.
- Do NOT alter the verbatim Stacks `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` text.
- No Lean tactic syntax in prose.
