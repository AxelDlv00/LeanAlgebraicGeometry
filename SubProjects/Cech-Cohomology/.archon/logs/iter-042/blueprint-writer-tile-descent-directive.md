# Blueprint-writer directive — fix `lem:tile_section_localization` sketch + add base-ring descent block

## Chapter to edit
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — ONLY this chapter.

## Strategy context (the slice that matters)
Route B keystone, sheaf-axiom equalizer route (Stacks 01HV(4)/01I8). The per-tile section-localisation
lemma `lem:tile_section_localization` (currently at tex lines ~4351–4387) feeds the kernel comparison
`lem:qcoh_section_kernel_comparison` → keystone `lem:qcoh_section_isLocalizedModule`. A prover attempted
`tile_section_localization` last iter (iter-041) and discovered the **current proof sketch is UNSOUND**:
it claims the section comparison is the definitional equality of `lem:restrict_obj_mathlib`
(`\Gamma(\mathcal{F}_{(g)}, V) = \Gamma(\mathcal{F}, \iota(V))`, rfl). It is NOT. The prover demonstrated
concretely (a `run_code` defeq failure) that the lemmas in this file (`section_isLocalizedModule_of_presentation`,
`qcoh_section_equalizer`) use a **different functor** than `restrict_obj`, so the comparison is a genuine
~100–150 LOC natural-iso construction plus a base-ring change — NOT wiring.

Your job is to make the sketch HONEST and adequate to guide formalization, and to add the missing
base-ring-descent lemma block (which already exists in Lean, axiom-clean, but has no blueprint block).

## The precise mathematical content (from the iter-041 prover's diagnosis — authoritative)

### Why the current sketch is wrong (the global-vs-local-ring functor mismatch)
- `lem:restrict_obj_mathlib` (`Scheme.Modules.restrict_obj`) is a rfl about **`SheafOfModules` sections**
  `\Gamma(\mathcal{M}, U) = \mathcal{M}.\mathrm{presheaf}.\mathrm{obj}(U)`, valued in `ModuleCat(\Gamma(U,\mathcal{O}))`
  — the **local ring** `\Gamma(U,\mathcal{O})`. It says `\Gamma(\mathcal{M}.\mathrm{restrict}\,\iota, U) =
  \Gamma(\mathcal{M}, \iota(U))` definitionally.
- But `section_isLocalizedModule_of_presentation` and `qcoh_section_equalizer` work with a **different functor**
  `modulesSpecToSheaf.obj F = forgetToSheafModuleCat ⋙ restrictScalars(R ≅ \Gamma(\top,\mathcal{O}))`,
  valued in `ModuleCat R` — the **global ring** `R`. `modulesSpecToSheaf` does NOT commute with `restrict`
  definitionally.
- Concrete failure (the prover verified by `run_code`): the carriers
  `((modulesSpecToSheaf.obj (modulesRestrictBasicOpen g F)).presheaf.obj (op \top))` and
  `((modulesSpecToSheaf.obj F).presheaf.obj (op (specBasicOpen g)))` are **NOT defeq** (`rfl` fails).
  They differ by **(i)** the base ring `R_g = Localization.Away g` vs `R`, AND **(ii)** the open
  `(specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ \top)` vs `specBasicOpen g` (provably equal,
  not rfl).

### The genuine remaining decomposition (encode this in the sketch)
The honest proof of `tile_section_localization` is:
1. B4 (`lem:presentation_modulesRestrictBasicOpen`) presents the tile `\mathcal{F}_{(g)}` globally over
   `\Spec R_g`. ✔ (DONE)
2. Apply `lem:section_isLocalizedModule_of_presentation` to the globally-presented `\mathcal{F}_{(g)}` and
   `\bar f = ` image of `f` in `R_g`: the section-restriction map
   `\Gamma_{R_g}(\top, \mathcal{F}_{(g)}) \to \Gamma_{R_g}(D(\bar f), \mathcal{F}_{(g)})` is a localisation
   at `\mathrm{powers}\,\bar f` **over `R_g`**. ✔ (DONE — but over `R_g`, NOT over `R`)
3. **(Sub-lemma A — opens identities.)** Identify the relevant image opens of the affine identification
   `\iota : \Spec R_g \cong D(g) \hookrightarrow X`:
   `(\mathrm{specBasicOpen}\,g).\iota\, ''ᵁ\, ((\mathrm{basicOpenIsoSpecAway}\,g).\mathrm{inv}\, ''ᵁ\, \top)
     = \mathrm{specBasicOpen}\,g` (i.e. `D(g)`), and
   `(\mathrm{specBasicOpen}\,g).\iota\, ''ᵁ\, ((\mathrm{basicOpenIsoSpecAway}\,g).\mathrm{inv}\, ''ᵁ\,
     (\mathrm{basicOpen}(\mathrm{algebraMap}\,R\,R_g\,f))) = \mathrm{specBasicOpen}(g f)` (i.e. `D(gf)`),
   using `D(gf) = D(g) \cap D(f)` (`PrimeSpectrum.basicOpen_mul`).
4. **(Sub-lemma B — the load-bearing section comparison, ~100–150 LOC, NOT rfl.)** Construct an `R_g`-linear
   (equivalently, via `IsScalarTower R R_g`, an `R`-compatible) isomorphism, **natural in the open `V` and
   intertwining the restriction maps**,
   `\Gamma_{R_g}(V, \mathcal{F}_{(g)}) \cong \Gamma_R((\mathrm{specBasicOpen}\,g).\iota\,''ᵁ\,(\mathrm{iso.inv}\,''ᵁ\,V), \mathcal{F})`.
   This is built from `lem:restrict_obj_mathlib` / `restrict_map` (the rfl at the **SheafOfModules** level,
   i.e. for `\Gamma(\mathcal{M}, -)` over the local ring) combined with the `restrictScalars` bookkeeping of
   `modulesSpecToSheaf` (the `StructureSheaf.globalSectionsIso` for `R_g`). It is the bridge between the
   `\Gamma(\mathcal{M}, -)` (local-ring) functor where `restrict_obj` is rfl and the
   `modulesSpecToSheaf.obj` (global-ring `R`) functor the localisation lemmas live in.
5. **(Base-ring descent.)** Transport step-2's `IsLocalizedModule(\mathrm{powers}\,\bar f)` across Sub-lemma B
   (an `IsLocalizedModule.of_linearEquiv`-style move, `R_g`-linear), THEN descend from `R_g` to `R` via the
   already-built lemma `\lean{AlgebraicGeometry.isLocalizedModule_powers_restrictScalars_of_algebraMap}`,
   using `IsScalarTower R R_g` on the section modules, matching the target map via Sub-lemma A. Result:
   `IsLocalizedModule(\mathrm{powers}\,f)` of `\Gamma(D(g),\mathcal{F}) \to \Gamma(D(gf),\mathcal{F})` **over `R`**.

The non-circularity hinge is unchanged and still holds: the localisation is on the **tile** `\mathcal{F}_{(g)}`
(where `\mathcal{F}` is `\widetilde{\cdot}`, globally presented), never on the global `\mathcal{F}` — the
keystone-at-`g` statement is NOT invoked.

## Tasks (do all of these in the one chapter)

1. **ADD a Mathlib-converse / project lemma block for the base-ring descent.** Place it just before
   `lem:tile_section_localization` (after `lem:localized_module_map_exact_mathlib`). Use:
   - `\label{lem:isLocalizedModule_powers_restrictScalars_of_algebraMap}`
   - `\lean{AlgebraicGeometry.isLocalizedModule_powers_restrictScalars_of_algebraMap}`
   - Statement: Let `A` be an `R`-algebra, `M, N` be `A`-modules with `IsScalarTower R A M`,
     `IsScalarTower R A N`, and `\varphi : M \to_{A} N` an `A`-linear map. If `\varphi` exhibits `N` as the
     localisation of `M` at `\mathrm{powers}(\mathrm{algebraMap}\,R\,A\,f)` (over `A`), then its `R`-linear
     restriction `\varphi.\mathrm{restrictScalars}\,R` exhibits `N` as the localisation of `M` at
     `\mathrm{powers}\,f` (over `R`). (This is the **converse** of Mathlib's
     `IsLocalizedModule.of_restrictScalars`, which Mathlib lacks.)
   - One-line informal proof: the three `IsLocalizedModule` clauses transfer directly; the only content is
     `(\mathrm{algebraMap}\,R\,A\,f)^k \cdot x = f^k \cdot x` (scalar tower) and reducing `map_units` to
     base-independent bijectivity via `Module.End.isUnit_iff`.
   - This is project-bespoke (no external citation needed — it is elementary algebra; no `% SOURCE` lines).
   - It is already proved in Lean and axiom-clean; do NOT add `\leanok` (sync_leanok owns it).

2. **REWRITE the proof sketch of `lem:tile_section_localization`** (currently lines ~4364–4387) to the
   honest 5-step decomposition above. Explicitly:
   - State that the section comparison is **NOT** `lem:restrict_obj_mathlib`-rfl: `restrict_obj` is rfl for
     the local-ring `\Gamma(\mathcal{M}, -)` functor, whereas the localisation lemmas use the global-ring
     `modulesSpecToSheaf.obj` functor, which does not commute with `restrict` definitionally. Keep a one-line
     `% NOTE:` recording that the naive "section comparison is restrict_obj-rfl" recipe (inherited from the
     old `bridge.md` B6) is UNSOUND and was disproved concretely in iter-041.
   - Describe Sub-lemma A (opens identities, step 3) and Sub-lemma B (the natural `R_g`-linear section
     comparison `\Gamma_{R_g}(V,\mathcal{F}_{(g)}) \cong \Gamma_R(\iota(V),\mathcal{F})`, step 4 — the
     load-bearing ~100–150 LOC piece) as named sub-steps of the proof. You MAY give them their own
     `\begin{lemma}` blocks if you prefer (suggested labels `lem:tile_image_opens_identities` and
     `lem:tile_section_comparison`, no `\lean{}` pin yet since the Lean decls are to-build — add a
     `% NOTE:` that the pins will be reconciled once built), or keep them inline as numbered steps. Either
     is acceptable; the key requirement is that the base-ring descent and the non-rfl section comparison are
     both explicit and that the sketch does NOT claim the comparison is definitional.
   - Add the base-ring descent step (step 5) invoking
     `\ref{lem:isLocalizedModule_powers_restrictScalars_of_algebraMap}`.
   - Update BOTH `\uses{}` (statement block AND proof block) of `lem:tile_section_localization` to add
     `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap`. Keep the existing deps
     (`lem:qcoh_finite_presentation_cover`, `lem:presentation_modulesRestrictBasicOpen`,
     `lem:section_isLocalizedModule_of_presentation`, `lem:restrict_obj_mathlib`). If you add Sub-lemma A/B
     blocks, add their labels to the `\uses{}` too.

3. **Coverage debt — bundle the private helper `res_trans_apply`.** In the `lem:qcoh_section_equalizer`
   block, add `AlgebraicGeometry.res_trans_apply` to its `\lean{...}` list (alongside
   `AlgebraicGeometry.qcoh_section_equalizer`) so the dependency graph stops flagging it as unmatched.
   (The existing `% NOTE` already mentions it; this makes the coverage edge real.)

## Out of scope (do NOT touch)
- Do NOT edit any other chapter or any block other than those named above.
- Do NOT add `\leanok` anywhere (sync_leanok owns it).
- Do NOT touch the keystone `lem:qcoh_section_isLocalizedModule` or kernel-comparison
  `lem:qcoh_section_kernel_comparison` blocks except to keep their `\uses{}` consistent if you rename a label
  (you should NOT need to rename anything).
- Do NOT alter the `lem:qcoh_section_equalizer` statement/proof prose (it is correct and HARD-GATE-cleared);
  the only edit there is adding the `res_trans_apply` name to its `\lean{}`.

## References
This content is project-bespoke categorical/algebraic plumbing; the governing source is Stacks 01HV(4)
(already cited elsewhere in the chapter for the equalizer route). No new reference retrieval needed — but
`references/**` is in your write domain in case you find a gap.
