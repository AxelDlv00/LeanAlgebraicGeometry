# Lean ↔ Blueprint Check Report

## Slug
cotangent-grpobj-review145

## Iteration
145

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/GrpObj.lean`
- Blueprint: `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`
  (pointer chapter; mathematical content lives in `RigidityKbar.tex`)

## Methodology note

The pointer chapter is structured as an `itemize` of `\texttt{...}`-referenced
declarations rather than `\lean{...}`-tagged statement blocks. There are
**zero** `\lean{...}` macros in the chapter (verified via grep). That makes
the standard per-`\lean{...}`-block table N/A. I therefore audit the per-item
list as the equivalent declaration manifest: each `\item` in the chapter is a
claim that the named declaration exists in the Lean file with the disposition
the bullet describes. The Lean file outline is the ground-truth side of the
comparison.

## Per-declaration

For every `\item` in the pointer chapter's "Lean declarations in this file"
itemize, one entry. Source-of-truth declaration list comes from the Lean
file outline; chapter line refs come from the pointer chapter.

### `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` (chapter line 22)
- **Lean target exists**: yes (`GrpObj.lean:162`).
- **Signature matches**: yes — `ModuleCat k`, with `{n : ℕ}`,
  `[SmoothOfRelativeDimension n G.hom]`, `[IsProper G.hom]`,
  `[GeometricallyIrreducible G.hom]` binders matching prose.
- **Proof follows sketch**: yes — the iter-131 `Classical.choose`-chain body
  shape (`smooth_locally_free_omega` → `let U / V / e / hxV / ψV` → outer
  `(ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of … Ω[…])`) is the body.
- **notes**: closed in-file; rank pinned by companion below.

### `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars` (chapter line 26)
- **Lean target exists**: yes (`GrpObj.lean:211`).
- **Signature matches**: yes — the chapter's "structural-shape acceptance
  lemma" reads as `∃ U V e htop, cotangentSpaceAtIdentity G = (extendScalars …).obj (ModuleCat.of … Ω[…])`,
  which matches the Lean statement.
- **Proof follows sketch**: yes — direct `Classical.choose`-chain reproduction
  + `rfl` on the witness.
- **notes**: chapter says "supports both \texttt{change}-based and
  \texttt{obtain}+\texttt{rw} rewrite patterns downstream" — Lean statement
  is `∃`-form, which supports both.

### `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq` (chapter line 30)
- **Lean target exists**: yes (`GrpObj.lean:257`).
- **Signature matches**: yes — `Module.finrank k (cotangentSpaceAtIdentity G) = n`.
- **Proof follows sketch**: yes — the chapter's Step 1 (chart-side Kähler
  rank via `Module.finrank_eq_of_rank_eq`) + Step 2 (`Module.finrank_baseChange`)
  is the proof.
- **notes**: closed iter-132; clean.

### `AlgebraicGeometry.GrpObj.shearMulRight` + companion simps (chapter lines 33–42)
- **Lean target exists**: yes — `shearMulRight` at `GrpObj.lean:350`,
  `shearMulRight_hom_fst` at line 387, `shearMulRight_hom_snd` at line 392.
- **Signature matches**: yes — `G ⊗ G ≅ G ⊗ G` with hom `lift (fst G G) μ`,
  and the simps lemmas state `hom ≫ fst = fst` and `hom ≫ snd = μ` matching
  the chapter prose.
- **Proof follows sketch**: yes — `lift_lift_assoc` + `lift_comp_inv_left/right`
  + `lift_comp_one_left` chase per `MonObj`/`GrpObj` API.
- **notes**: now an orphan-helper post-excise — see "Blueprint adequacy".

### `AlgebraicGeometry.GrpObj.schemeHomRingCompatibility` (chapter lines 43–51)
- **Lean target exists**: yes (`GrpObj.lean:424`).
- **Signature matches**: yes — `(TopCat.Presheaf.pullback CommRingCat f.base).obj Z.presheaf ⟶ Y.presheaf`,
  obtained via `pullbackPushforwardAdjunction.homEquiv.symm f.c`.
- **Proof follows sketch**: N/A (definition; chapter's description of it as
  "adjunction transpose of `f.c`" matches the body).
- **notes**: the chapter's caveat "this is *not* the φ for
  `PresheafOfModules.pullback`" is reflected in the in-file docstring;
  consistent. After the iter-145 excise, the explicit downstream consumers
  inside this file are gone; the chapter still cites
  `relativeDifferentialsPresheaf` as the (external) consumer, which is
  accurate since that definition lives upstream in `AlgebraicJacobian/Differentials.lean`.

### `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two` (chapter lines 52–58)
- **Lean target exists**: **NO** — EXCISED iter-145. Closest reference in
  Lean: a comment at `GrpObj.lean:552–560` documenting the excise.
- **Signature matches**: N/A — declaration removed.
- **Proof follows sketch**: N/A.
- **notes**: **Stale**. The chapter prose says
  "Iter-138 prover landed PARTIAL with substantive Route (b) skeleton; three
  concrete sub-sorries remain inside this declaration's body and inside the
  two helpers below (iter-140 prover targets)." This bullet was **not updated
  to reflect the iter-145 excise**; it still presents the declaration as
  live work-in-progress, not as descoped/excised. The other DESCOPED bullets
  (lines 59–110, 115–125) each carry an explicit
  "\textbf{DESCOPED iter-145+ ... preserved in-tree as auditable record}"
  marker; this one does not.

### `AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_derivation` (chapter lines 59–79)
- **Lean target exists**: **NO** — EXCISED iter-145.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: chapter carries a DESCOPED iter-145+ marker, but the disposition
  it asserts is "preserved in-tree as auditable record of the bundled route".
  The declaration is **not** in-tree any more — it was deleted. The marker is
  honest about the descope decision but inaccurate about the file state.

### `AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv` (chapter lines 80–97)
- **Lean target exists**: **NO** — EXCISED iter-145.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: chapter has a DESCOPED iter-145+ marker but text still describes
  the declaration as "Sorry-free in Lean iter-138" and references the
  consuming relationship with the (also-excised)
  `relativeDifferentialsPresheaf_basechange_along_proj_two`. State now stale.

### `AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso` (chapter lines 98–110)
- **Lean target exists**: **NO** — EXCISED iter-145.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: chapter says "preserved as auditable record" — same drift as
  above. Honest about descope, inaccurate about file state.

### `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section` (chapter lines 111–114)
- **Lean target exists**: yes (`GrpObj.lean:579`).
- **Signature matches**: yes — both nested-`PresheafOfModules.pullback` LHS
  and RHS shapes match the prose `s^*(pr_2^* Ω_{G/k}) ≅ π_G^*(η_G^* Ω_{G/k})`.
- **Proof follows sketch**: yes — `PresheafOfModules.pullbackComp` on both
  sides + `eqToIso` driven by `section_snd_eq_identity_struct` (the
  categorical identity helper at line 458). Matches the chapter's Step 3
  prose.
- **notes**: closed iter-136 (no sorry). Now an orphan-helper post-excise:
  the chapter still mentions it as Step 3 of `mulRight_globalises`, but the
  Main lemma (Step 3's downstream consumer) was excised. Chapter does NOT
  flag the orphan status.

### `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent` (chapter lines 115–125)
- **Lean target exists**: **NO** — EXCISED iter-145.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: chapter has a DESCOPED iter-145+ marker, but asserts
  "Body remains \texttt{sorry} as auditable record" — declaration is in fact
  deleted, not sorry-bodied. Honest about descope, inaccurate about file
  state.

## Red flags

### Placeholder / suspect bodies
None in the surviving declarations. All surviving bodies are sorry-free
(verified via the iter-145 lean-auditor report and the clean
`lean_diagnostic_messages` run).

### Excuse-comments
None on surviving declarations. The two `iter-145 EXCISE:` block comments
at `GrpObj.lean:552–560` and `GrpObj.lean:624–629` are factual excise
records, not workflow excuses.

### Axioms / Classical.choice on non-trivial claims
`cotangentSpaceAtIdentity` is built with a `Classical.choose`-chain on
`Scheme.smooth_locally_free_omega`. This is the iter-131-sanctioned body
shape and is documented in both the in-file docstring (lines 116–161) and
the chapter (`cotangentSpaceAtIdentity` bullet at chapter line 22).
`cotangentSpaceAtIdentity_eq_extendScalars` (line 211) exposes the structural
shape downstream. Not a red flag.

### Stale-comment drift inside the Lean file (informational)
The headers at `GrpObj.lean:297–326` and `GrpObj.lean:398–406`/`428–451`
extensively describe the now-excised Step 2 + Main composition machinery.
The headers are not Lean declarations and do not produce errors, but they
are now stale narrative around the surviving orphan-helpers. This is a
Lean-side housekeeping observation, not a blueprint↔Lean mismatch.

## Unreferenced declarations (informational)

The chapter's `\item` list covers every public surviving declaration. Two
`private` declarations exist in the Lean file:

- `GrpObj.lean:458` `section_snd_eq_identity_struct` — `private lemma`; used
  by `relativeDifferentialsPresheaf_restrict_along_identity_section`.
  Helper-only, not expected in the pointer chapter.
- `GrpObj.lean:544` `isIso_of_app_iso_module` — `private theorem`; its only
  in-file consumer was the excised
  `relativeDifferentialsPresheaf_basechange_along_proj_two`. Now an orphan
  helper. Not in the chapter; given its `private` scope and the fact that
  its docstring already flags it as "Upstream-PR candidate", listing it in
  the chapter is optional. Informational only.

## Blueprint adequacy for this file

- **Coverage**: 7 / 7 public surviving declarations have a corresponding
  `\item` in the chapter (3× piece (i.a) trio + `shearMulRight` (with two
  simps) + `schemeHomRingCompatibility` +
  `relativeDifferentialsPresheaf_restrict_along_identity_section`).
  Unreferenced declarations: 2 private helpers (acceptable) +
  0 substantive (none flagged).
  **However**: 5 chapter `\item`s reference declarations that no longer
  exist in the Lean file (the iter-145 excise group). That is a manifest
  drift in the other direction.
- **Proof-sketch depth**: N/A for the pointer chapter (it explicitly defers
  proof sketches to `RigidityKbar.tex`). The `cotangentSpaceAtIdentity`,
  `cotangentSpaceAtIdentity_finrank_eq`, and
  `relativeDifferentialsPresheaf_restrict_along_identity_section` bullets
  each carry a one-line method gloss that's consistent with the in-file
  docstrings; that is the right level for a pointer chapter.
- **Hint precision**: N/A — no `\lean{...}` macros in this chapter. The
  declaration manifest uses `\texttt{Namespace.name}` references, which all
  resolve to the qualified Lean names. (For the 5 excised entries, the names
  no longer resolve, but the convention used is not `\lean{...}` so the
  blueprint compiler does not currently raise a "declaration not found".
  Still a manifest-drift issue.)
- **Generality**: matches need for the surviving declarations.
- **Recommended chapter-side actions**:
  - Remove or rewrite to "EXCISED iter-145" the 5 bullets referencing
    the iter-145-deleted declarations:
    - `relativeDifferentialsPresheaf_basechange_along_proj_two`
      (lines 52–58 — also missing any iter-145 disposition marker)
    - `basechange_along_proj_two_inv_derivation` (lines 59–79)
    - `basechange_along_proj_two_inv` (lines 80–97)
    - `basechange_along_proj_two_inv_app_isIso` (lines 98–110)
    - `mulRight_globalises_cotangent` (lines 115–125)
    The current "DESCOPED iter-145+ ... preserved in-tree as auditable
    record" disposition is *inaccurate*: the declarations are not in-tree.
    They should be marked `EXCISED iter-145` or the bullets should be
    removed and the chapter's iter-144 disposition note (lines 10–17)
    updated to read "excised" rather than "preserved as auditable record".
  - Optionally flag the now-orphan-helper status of `shearMulRight`,
    `shearMulRight_hom_fst`, `shearMulRight_hom_snd`,
    `schemeHomRingCompatibility`, and
    `relativeDifferentialsPresheaf_restrict_along_identity_section`. The
    chapter currently describes their role as Step 1 / Step 3 / packaging
    helper for the bundled route, but the bundled-route consumers are gone
    iter-145; the chapter does not mention that these are kept solely as
    project infrastructure that no live consumer in this file uses.
  - Update the chapter's iter-144-disposition paragraph (lines 10–17) so
    its "remaining \texttt{sorry}-bodied declarations are preserved as
    auditable record of the bundled route" sentence matches reality. After
    the iter-145 excise, the only surviving sorry-bodied content is none
    in this file — the chapter sentence is structurally wrong.

## Severity summary

- **must-fix-this-iter**:
  - **Blueprint-manifest drift on 5 declarations**: chapter `\item`s for
    `relativeDifferentialsPresheaf_basechange_along_proj_two`,
    `basechange_along_proj_two_inv_derivation`,
    `basechange_along_proj_two_inv`,
    `basechange_along_proj_two_inv_app_isIso`, and
    `mulRight_globalises_cotangent` describe Lean state that no longer
    exists. The directive's gate language ("If the pointer chapter still
    lists the excised declarations as live blueprint blocks with `\lean{...}`
    hints to declaration names that no longer exist in the Lean file, that
    is a must-fix Lean ↔ blueprint signature mismatch") technically only
    fires for `\lean{...}` hints, and this chapter uses `\texttt{...}`
    instead. The strict reading of the gate would call this **major** rather
    than must-fix. I classify it **must-fix** anyway because (a) the
    chapter's iter-144-disposition paragraph at lines 10–17 actively
    asserts the excised declarations are "preserved as auditable record",
    which is false; and (b) one of the five (`...basechange_along_proj_two`,
    chapter lines 52–58) lacks even a DESCOPED marker — its prose
    presents the declaration as live iter-138 PARTIAL work-in-progress.
    That bullet is an active falsehood about Lean state, not just a stale
    disposition note. Plan agent should call the blueprint-writing subagent
    to land the chapter-side fix listed in "Recommended chapter-side
    actions" above.

- **major**:
  - None separately. The four DESCOPED-marked bullets (lines 59–110, 115–125)
    are honest about the descope decision but inaccurate about file state;
    they're rolled into the must-fix above rather than a separate finding.

- **minor**:
  - Orphan-helper status of `shearMulRight` (+simps),
    `schemeHomRingCompatibility`, and
    `relativeDifferentialsPresheaf_restrict_along_identity_section` is not
    flagged in the chapter; their role descriptions still cast them as
    components of the descoped bundled route. Low-impact prose-vs-Lean
    drift.
  - The Lean-side comment headers at `GrpObj.lean:297–326`, `398–406`,
    `428–451`, `465–525` extensively describe the excised Step 2 / Main
    machinery in present tense. Pure Lean-housekeeping; doesn't affect
    blueprint↔Lean correspondence but downstream maintenance reads will
    find the file's section structure confusing.

Overall verdict: surviving declarations match the pointer chapter faithfully
and build clean; the chapter's manifest is out of date relative to the iter-145
excise — 5 `\item`s describe declarations that have been deleted from the
Lean file, including one (`...basechange_along_proj_two`, lines 52–58)
that lacks any iter-145 disposition and still presents itself as live
WIP — must-fix this iter via the blueprint-writing subagent.
