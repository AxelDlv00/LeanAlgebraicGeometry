# Lean ↔ Blueprint Check Report

## Slug
lvb-csi-iter064

## Iteration
064

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` (1420 lines, 4 sorries)
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (consolidated chapter)

---

## Per-declaration

### `\lean{CategoryTheory.sigmaOptionIso}` (chapter: `lem:sigmaOptionIso`, line 8221)
- **Lean target exists**: yes (line 398–417)
- **Signature matches**: yes — `∐ Z ≅ Z none ⨿ (∐ a, Z (some a))` with correct instance binders
- **Proof follows sketch**: yes — blueprint says forward = `Sigma.desc` none→inl / some→inl∘inr, inverse = `coprod.desc`; Lean body matches exactly
- **notes**: clean, no sorry

### `\lean{AlgebraicGeometry.pushPullObjCongr}` (chapter: `lem:pushPullObjCongr`, line 8247)
- **Lean target exists**: yes (line 897–902)
- **Signature matches**: yes — `F : X.Modules, e : Y ≅ Y' in Over X → pushPullObj F Y ≅ pushPullObj F Y'`
- **Proof follows sketch**: yes — forward `pushPullMap F e.inv`, backward `pushPullMap F e.hom`, round-trips by `pushPullMap_comp` and `pushPullMap_id`
- **notes**: clean, no sorry

### `\lean{AlgebraicGeometry.overSigmaOptionIso}` (chapter: `lem:over_sigmaOptionIso`, line 8264)
- **Lean target exists**: yes (line 909–922)
- **Signature matches**: yes — `Over.mk (Sigma.desc ...) ≅ Over.mk (coprod.desc ... (Sigma.desc ...))`
- **Proof follows sketch**: yes — `Over.isoMk` of `sigmaOptionIso`, structure-map compatibility checked by `Sigma.hom_ext` on each `none`/`some` case
- **notes**: clean, no sorry

### `\lean{AlgebraicGeometry.piOptionIso}` (chapter: `lem:piOptionIso`, line 8290)
- **Lean target exists**: yes (line 926–945)
- **Signature matches**: yes — `∏ᶜ W ≅ W none ⨯ (∏ᶜ a, W (some a))`
- **Proof follows sketch**: yes — dual construction to `sigmaOptionIso`, all round-trips by `Pi.hom_ext`/`prod.hom_ext`
- **notes**: clean, no sorry

### `\lean{AlgebraicGeometry.pushPull_coprod_prod_empty}` (chapter: `lem:pushPull_coprod_prod_empty`, line 8306)
- **Lean target exists**: yes (line 968–984)
- **Signature matches**: yes — `IsIso (coprodToProdMap F legs)` for `legs : PEmpty.{u+1} → Over X`
- **Proof follows sketch**: **partial** — blueprint says reduce via `isIso_modules_of_toPresheaf` to sections, argue zero sections in initial scheme. Lean instead uses `Limits.isIso_of_isTerminal` comparing both sides as terminal objects and calls `Functor.map_isZero`. Both are valid routes but the Lean route deviates from the blueprint's `isIso_modules_of_toPresheaf` approach.
- **notes**: **has `sorry` at line 983** for `IsZero ((Scheme.Modules.pullback q).obj F)` when `q` maps out of `∐ PEmpty`. The commentary is honest about what is missing. The blueprint's proof strategy (zero sections over every V) is mathematically equivalent but does not name the specific `IsZero` tool needed.

### `\lean{AlgebraicGeometry.pushPull_coprod_prod}` (chapter: `lem:pushPull_coprod_prod`, line 8333)
- **Lean target exists**: yes (line 1118–1123) — assembles via `isIso_coprodToProdMap`
- **Signature matches**: yes — `pushPullObj F (Over.mk (Sigma.desc ...)) ≅ ∏ᶜ i, pushPullObj F (legs i)` for finite `ι`
- **Proof follows sketch**: yes for structure — `Finite.induction_empty_option` with three leaves as described in the blueprint proof. The `coprodToProd_isIso_option` leaf is CLOSED axiom-clean (iter-064). Two leaves remain open (see red flags below).
- **notes**: declaration body is a one-liner (`asIso (coprodToProdMap F legs)` using `isIso_coprodToProdMap`), but transitively sorry-laden through two private leaves. No `\leanok` on the proof block — correct.

### `\lean{AlgebraicGeometry.pushPull_sigma_iso}` (chapter: `lem:pushPull_sigma_iso`, line 8396; `\leanok` on statement+proof)
- **Lean target exists**: yes (line 1166–1178)
- **Signature matches**: yes — `pushPullObj F (coverCechNerveOver 𝒰).obj (op [p]) ≅ ∏ᶜ σ, pushPullObj F (Over.mk j_σ)`
- **Proof follows sketch**: yes — three-step chain: `pushPullObjCongr` (Stub 1 backbone), `pushPullObjCongr` (`overSigmaDescIso`), `pushPull_coprod_prod`
- **notes**: direct body sorry-free. Blueprint `\leanok` on both statement and proof blocks is accurate for the direct body. Transitively depends on the two open leaves of `pushPull_coprod_prod`; the blueprint's `\leanok` reflects the direct-body state, which is correct per the `sync_leanok` protocol.

### `\lean{AlgebraicGeometry.pushPull_leg_sections}` (chapter: `lem:pushPull_leg_sections`; `\leanok`)
- **Lean target exists**: yes (line 1211–1231)
- **Signature matches**: yes — `Γ(V, pushPullObj F (Over.mk j_σ)) ≅ Γ(U_σ ⊓ V, F)` as Ab objects
- **Proof follows sketch**: yes — three-step: preimage sections (rfl), `restrictFunctorIsoPullback`, `image_preimage_eq_opensRange_inf` rewrite
- **notes**: clean, no sorry

### `\lean{AlgebraicGeometry.pushPull_eval_prod_iso}` (chapter: `lem:pushPull_eval_prod_iso`; `\leanok`)
- **Lean target exists**: yes (line 1260–1288)
- **Signature matches**: yes — `Γ(V, pushPullObj F Y_p) ≅ ∏ᶜ σ, Γ(U_σ ⊓ V, F)` in Ab
- **Proof follows sketch**: yes — chains `pushPull_sigma_iso`, preservation of limits by evaluation, `pushPull_leg_sections`
- **notes**: clean, no sorry in direct body

### `\lean{AlgebraicGeometry.cechSection_complex_iso, AlgebraicGeometry.sectionCechComplexV}` (chapter: `lem:cechSection_complex_iso`, line 8492)
- **Lean target exists**: yes (line 1343–1358 and 1295)
- **Signature matches**: yes — `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε` where `D` is the evaluated augmented Čech complex; the augmented form is correctly targeted (fixing the earlier mistake noted in blueprint NOTE)
- **Proof follows sketch**: N/A — body is `:= sorry` (full placeholder)
- **notes**: **sorry at line 1358**. No `\leanok` on statement block — **inconsistency with `sync_leanok` protocol**: the declaration exists with a sorry body and should carry `\leanok` on the statement block (the proof block's `\leanok` is correctly absent). This may indicate `sync_leanok` ran before this declaration was wired or the type's `let` bindings confused the sorry-counter.

### `\lean{AlgebraicGeometry.cechSection_contractible}` (chapter: `lem:cechSection_contractible`, line 8568; `\leanok` on statement block)
- **Lean target exists**: yes (line 1410–1417)
- **Signature matches**: yes — `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0`, augmented form correctly targeted
- **Proof follows sketch**: N/A — body is `:= sorry` (full placeholder)
- **notes**: **sorry at line 1417**. Blueprint `\leanok` on statement block is correct (declaration exists with sorry). Blueprint proof sketch (augmentation node + `depHomotopy` engine for Čech degrees) is detailed and actionable.

---

## Red flags

### Placeholder / suspect bodies

- **`pushPull_coprod_prod_empty`** at line 983: `sorry` for `IsZero ((Scheme.Modules.pullback q).obj F)` where `q : ∐ PEmpty → X`. The blueprint claims a substantive proof (zero sections over empty initial scheme). This is a genuine open obligation, not a triviality.

- **`coprodToProd_isIso_of_equiv`** at line 999: entire body is `:= sorry`. The blueprint for this step (the "Reindexing" sub-case of `lem:pushPull_coprod_prod`'s proof) consists of one sentence: "the canonical product and coproduct framings transport along the reindexing isomorphisms of products and coproducts while preserving the canonical form." No Lean tools named, no canonical-form preservation argument sketched. The Lean doc-string (lines 991–998) contains a significantly more detailed strategy than the blueprint. This is simultaneously a Lean red flag (placeholder on a substantive claim) and a blueprint adequacy failure (the blueprint prose is insufficient to guide formalization).

- **`cechSection_complex_iso`** at line 1358: entire body is `:= sorry` (Stub 5 unimplemented). Blueprint proof is detailed and adequate.

- **`cechSection_contractible`** at line 1417: entire body is `:= sorry` (Stub 6 unimplemented). Blueprint proof is detailed and adequate.

### Excuse-comments
None found. Doc-string comments in the Lean file accurately describe the mathematical content and the open gaps, with no "wrong but works for now" language.

### Axioms / Classical.choice on non-trivial claims
No new `axiom` declarations introduced in this file. The 4 sorries are standard `sorry` placeholders.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no dedicated `\lean{}` blueprint entry. Most are private proof-engineering helpers; the notable substantive ones are flagged:

**Abstract categorical helpers (CategoryTheory namespace) — acceptable, project-local prelims:**
- `widePullback_overX_isLimit`, `widePullback_overX_eq_prod` (blueprint: `lem:widePullback_overX_isLimit/eq_prod` referenced in doc-strings but not `\lean{}`-tagged — **minor** coverage gap)
- `overSigmaDescCofan`, `overSigmaDescIsColimit`, `overSigmaDescIso` (abstract versions of cover-arrow cofan lemmas; `overSigmaDescIso` is referenced in `pushPull_sigma_iso` via doc-string but not in blueprint — minor)
- `FinitaryPreExtensive.prodFinSuccIso`, `coprodFirst_distrib`, `pcd_hom_fst`, `pcd_hom_snd`, `cf_hom_fst`, `overSigma_hom_eq`, `overProd_coproduct_distrib`, `overProd_coproduct_distrib_right`, `widePullback_coproduct_iso_zero`, `widePullback_coproduct_iso`, `prod_coproduct_distrib`, `coproduct_fibrePower_reindex` (Stub-1 categorical engine; most have `lem:` labels in the doc-strings but are not tagged in the blueprint — these are deep categorical lemmas that the plan agent should backfill with `\lean{}` hints)

**Geometric helpers (AlgebraicGeometry namespace):**
- `widePullbackBaseCongr`, `cechBackbone_obj_widePullback`, `coverInterProdIso`, `coverArrowOverCofan`, `coverArrowOverIsColimit`, `coverArrowOverSigmaIso`, `widePullback_openImm_inter` — these appear to have blueprint lemma entries (e.g., `lem:widePullback_openImm_inter`, `lem:coverInterProdIso`) but were not reached by my grep. Minor coverage to verify.
- `isIso_coprodDecompMap`, `coprodDecompMap`, `pushPullCoprodLegIso`, `pushPull_binary_leg_coherence`, `pushPull_binary_coprod_prod` — all have blueprint entries (verified).

**Private proof helpers with no blueprint entry (acceptable):**
- `isIso_prodLift_of_isLimit`, `isIso_map_prodLift_of_isLimit` (general categorical tools)
- `coprodOverIncl` — **notable**: defines the canonical coproduct inclusion morphism in `Over X`; used as the framing in `coprodToProdMap` and named in 8+ locations. No dedicated blueprint entry. The blueprint's proof of `lem:pushPull_coprod_prod` references the "canonical form as `Pi.lift` of push–pull maps of the coproduct inclusions" but never names `coprodOverIncl`. **Major coverage debt** — see blueprint adequacy section.
- `coprodToProdMap` — **notable**: the canonical comparison map whose `IsIso` status is the thesis of all three induction lemmas. No dedicated blueprint entry. Similarly unaddressed in blueprint. **Major coverage debt**.
- `pushPull_binary_coprod_prod_hom` — private coherence lemma for the canonical form of the binary case hom; acceptable as an internal tool
- `pushPullObjCongr_hom`, `coprodToProdMap_comp_π`, `piOptionIso_inv_π_none`, `piOptionIso_inv_π_some` — private projection/coherence lemmas used in `coprodToProd_isIso_option` (now closed); acceptable
- `isIso_coprodToProdMap` — private master induction; no blueprint entry needed
- `coprodToProd_isIso_option` — **notable**: the Option-adjoining induction leaf, CLOSED in iter-064, but has no blueprint entry. The only reference is inline in the proof of `lem:pushPull_coprod_prod`. Now that it is closed, this is historical; but the lack of a blueprint entry means there is no recoverable proof record in the chapter.
- `coprodToProd_isIso_of_equiv` — **notable and open**: the reindexing induction leaf, still a full sorry; has no standalone blueprint entry (see must-fix below).
- `sectionCechComplexV` — tagged inside `lem:cechSection_complex_iso`'s `\lean{}` hint; acceptable

---

## Blueprint adequacy for this file

### Coverage
Of the 11 substantive groups of declarations verified above, 9 have proper `\lean{...}` entries. The remaining 2 notable gaps:

1. **`coprodToProdMap` and `coprodOverIncl`** — the two load-bearing definitions (framing for the entire induction) have no dedicated blueprint blocks. The blueprint names the "canonical product of push–pull maps" informally but never introduces `coprodToProdMap` as a named term. A prover starting fresh from the blueprint would need to invent this framing independently.

2. **`coprodToProd_isIso_of_equiv`** — no standalone `\lean{}` block, no dedicated lemma block. The reindexing induction step is described in one sentence of the proof of `lem:pushPull_coprod_prod`. **This is the primary reason this leaf has a full sorry in iter-064**: the prover did not have enough blueprint guidance to formalize it.

### Proof-sketch depth
- **adequate** for: `pushPull_coprod_prod_empty`, `cechSection_complex_iso` (Stub 5), `cechSection_contractible` (Stub 6), all closed declarations
- **under-specified** for: `coprodToProd_isIso_of_equiv` — the blueprint's one sentence ("transport along reindexing isomorphisms of products and coproducts while preserving the canonical form") does not name `Sigma.whiskerEquiv`, `Pi.whiskerEquiv`/`Limits.Pi.mapIso`, or explain how to prove that `coprodToProdMap F legs = transportedIso.hom` in `Pi.lift` form. The Lean doc-string itself (lines 991–998) is three times as detailed as the blueprint sketch. **This is a blueprint-side failure.**

### Hint precision
- **precise** for all entries that have `\lean{}` tags
- `lem:pushPull_coprod_prod` NOTE comment now correctly says "BUILT" (updated from "does not exist yet" in a prior review pass — acceptable)

### Generality
- **matches need** — no parallel APIs written; all generality levels match what downstream consumers need

### Recommended chapter-side actions

1. **Add `\begin{lemma}...\begin{proof}` block for `coprodToProd_isIso_of_equiv`** with:
   - `\lean{AlgebraicGeometry.coprodToProd_isIso_of_equiv}` tag
   - Route: given `e : α ≃ β`, apply `ih` to `legs ∘ e`; transport the source via `Sigma.whiskerEquiv e (fun _ => Iso.refl _)` composed with `overSigmaDescIso` to get `∐_β legs ≅ ∐_α (legs∘e)`; transport the target via `Limits.Pi.mapIso (fun a => Iso.refl _)` along `e` to get `∏_α (legs∘e) ≅ ∏_β legs`; identify `coprodToProdMap F legs` with the transported `coprodToProdMap F (legs∘e)` by checking each `Pi.π` projection via `coprodToProdMap_comp_π` and naturality of `pushPullMap`.

2. **Add named definition blocks for `coprodToProdMap` and `coprodOverIncl`** (or fold them into the statement of `lem:pushPull_coprod_prod` as explicit named constructions).

3. **Add `\leanok` to the statement block of `lem:cechSection_complex_iso`** — the declaration exists with a sorry body; the marker is missing (likely a sync_leanok miss from the iter-064 wiring).

4. **After `pushPull_coprod_prod_empty` is closed**, verify the blueprint proof text is updated to match the Lean route (the Lean uses `Functor.map_isZero` / `IsZero` rather than the `isIso_modules_of_toPresheaf` + zero-sections approach in the current blueprint text).

---

## Severity summary

### Must-fix-this-iter

1. **`pushPull_coprod_prod_empty` — sorry at line 983**: placeholder body on a substantive claim (IsZero of module pulled back to `∐ PEmpty`). Blueprint claims substantive proof.

2. **`coprodToProd_isIso_of_equiv` — full sorry at line 999**: placeholder body AND the blueprint proof sketch is too thin (one sentence, no Lean tools, no canonical-form preservation argument) to guide formalization. This is simultaneously a Lean red flag and a blueprint adequacy failure. The blueprint-writing subagent must add a dedicated lemma block before the next prover round.

3. **`cechSection_complex_iso` — full sorry at line 1358**: placeholder body on Stub 5. Blueprint proof is detailed; the sorry is unimplemented work.

4. **`cechSection_contractible` — full sorry at line 1417**: placeholder body on Stub 6. Blueprint proof is detailed; the sorry is unimplemented work.

### Major

5. **Coverage debt — no `\lean{}` entries for `coprodToProdMap` and `coprodOverIncl`**: these are the load-bearing framing definitions whose canonical form is the entire pivot of the induction; the blueprint should name and tag them.

6. **Coverage debt — no standalone blueprint block for `coprodToProd_isIso_option`** (now CLOSED): the proof is done, but the chapter has no record of this sub-lemma. Not blocking, but leaves an invisible gap for future audits.

### Minor

7. **Missing `\leanok` on `lem:cechSection_complex_iso` statement block**: declaration exists with sorry, marker should have been added by `sync_leanok` — likely a sync miss.

8. **Several abstract categorical lemmas in `CategoryTheory.FinitaryPreExtensive` namespace** (`widePullback_coproduct_iso`, `overProd_coproduct_distrib`, etc.) are referenced only in doc-strings and lack `\lean{}` blueprint entries. These are Stub-1 infrastructure; the plan agent should tag them in the chapter if they are stable.

---

**Overall verdict**: 4 sorries in 4 declarations — 2 in the `pushPull_coprod_prod` induction leaves (empty-base and reindex), 2 in Stubs 5/6 — with one blueprint adequacy failure (`coprodToProd_isIso_of_equiv` is under-specified and needs a dedicated lemma block before the next prover round. All other blueprint↔Lean pairs are correct and well-aligned.
