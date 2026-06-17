# blueprint-writer directive — `Picard_TensorObjSubstrate.tex` (iter-241)

## Scope (one chapter only)
Edit ONLY `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. Do not touch any other chapter.

## Why
iter-240's prover landed two NEW axiom-clean declarations that are the load-bearing coherence
ingredients of `lem:pullback_unit_iso` (§ `sec:tensorobj_pullback_monoidality`), but they have no
blueprint pin. The lean-vs-blueprint checker (ts240-tensorobj) flagged this as a MAJOR gap: the two
decls are unpinned, and the `lem:pullback_unit_iso` proof sketch calls the now-proved composition
coherence "the small remaining work" when in fact it is DONE. Bring the chapter into line with the Lean.

## Required edits

1. **Add a pinned sub-lemma block for the pullback-side composition coherence** — the genuinely-new
   ingredient. The Lean declaration is:
   `AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp`.
   Mathematical content (state in project notation, NO Lean tactics): for composable scheme morphisms
   `h : Z → Y`, `f : Y → X`, the pullback-side unit comparison `pullbackObjUnitToUnit` satisfies the
   composition coherence
   \[
     \mathrm{pbu}(h \mathbin{;} f) \;=\;
       (\mathrm{pullbackComp}\,h\,f).\mathrm{inv} \mathbin{;}
       (\mathrm{pullback}\,h).\mathrm{map}(\mathrm{pbu}\,f) \mathbin{;}
       \mathrm{pbu}\,h ,
   \]
   where `pbu` abbreviates `SheafOfModules.pullbackObjUnitToUnit` and `pullbackComp` is the
   pseudofunctoriality iso `(h ; f)^* ≅ h^* ∘ f^*`. This is the pullback-side (left-adjoint) mate of the
   pushforward-side coherence, obtained by adjunction-mate transport across the
   pullback–pushforward adjunction. It is Mathlib-absent at the pinned commit. Give it a `\label`
   (suggest `lem:pullbackObjUnitToUnit_comp`) and `\lean{...}`. This is Archon-original project
   infrastructure (no external source line needed — it stands on the proof sketch).

2. **Add a pinned sub-lemma block for the pushforward-side composition coherence.** Lean decl:
   `AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp`. Content: the right-adjoint
   (pushforward) unit comparison `unitToPushforwardObjUnit` satisfies the dual composition coherence;
   it is sectionwise just the structure-sheaf ring map, so the identity is definitional after the
   ext chain. Give it a `\label` (suggest `lem:unitToPushforwardObjUnit_comp`) and `\lean{...}`.
   Archon-original. Note it is the input the mate transport in (1) consumes.

3. **Revise the `lem:pullback_unit_iso` proof sketch** (currently lines ~2752–2786). It presently ends
   "the small remaining work is the naturality lemma tying the restricted global `pullbackObjUnitToUnit`
   to the local one." Update so that:
   - it `\uses{}` the two new sub-lemmas above;
   - it states that the composition coherence is now PROVED (the two new lemmas), so what is reused is
     the per-chart factorization `V.ι ; f = g ; U.ι` with `g = f.resLE U V`, the Final-chart instance
     `instIsIsoPullbackObjUnitToUnitOfFinal`, and the globalizer `isIso_of_isIso_restrict`;
   - it records that the SOLE remaining step is assembling these into the global iso — a per-chart
     `IsIso (pbu (V.ι ; f))` obtained from the coherence equation `pbu(V.ι;f) = (pullbackComp …).inv ;
     (pullback V.ι).map (pbu f) ; pbu (V.ι)` (a composite of isos), transported across
     `restrictFunctorIsoPullback`, then globalized. Keep the prose at textbook level; no Lean tactics,
     no mention of `infer_instance` / instance-synthesis plumbing (that is a Lean-implementation
     concern, not mathematical content).

## Out of scope
- Do NOT modify `lem:pullback_tensor_iso`, `lem:isinvertible_pullback`, or any group-law section.
- Do NOT add/remove `\leanok` or `\mathlibok` (managed by sync / review).
- Do NOT touch the deferred dual-bridge material.
- Keep the chapter's existing Stacks SOURCE QUOTE comments byte-intact.

If you find you need a source you do not have, you may dispatch a reference-retriever (your write-domain
includes `references/**`); but these two coherence lemmas are Archon-original, so no external source is
expected.
