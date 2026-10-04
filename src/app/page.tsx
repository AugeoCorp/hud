import { Layer } from "@/app/components/Layer";
import { StereoStage } from "@/app/components/StereoStage";

import styles from "./page.module.css";

// Depths are a starting guess, not tuned on the glasses yet.
export default function Home() {
	return (
		<StereoStage>
			<Layer depth={24}>
				<div className={styles.panel} />
			</Layer>
			<Layer depth={0}>
				<h1 className={styles.message}>Hello, world</h1>
			</Layer>
			<Layer depth={-12}>
				<span className={styles.badge}>
					<span className={styles.flat}>2D</span>
					<span className={styles.stereo}>3D</span>
				</span>
			</Layer>
		</StereoStage>
	);
}
